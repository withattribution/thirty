//
//  DTRequests.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonRequests.h"
#import "MurmurHash.h"

@interface DTCommonRequests()

#warning maybe possibly reorganize into an intent specific class

+ (BFTask *)userNotLoggedIn;
+ (BFTask *)userHasNoActiveIntent;

+ (BFTask *)unPinActiveIntent;
+ (BFTask *)unPinAndClearCache;
+ (BFTask *)unPinAndRemoveActiveIntentFromCache;

+ (BFTask *)pinActiveIntentForCurrentUser:(PFObject *)intent;
+ (BFTask *)pinAndCacheActiveIntent:(PFObject *)intent;

+ (BFTask *)queryActiveIntentForUserFromService:(PFUser *)user;
+ (BFTask *)queryCurrentUserObjectWithActiveIntentKeyFromService;

+ (BFTask *)queryPinnedActiveIntentForCurrentUser;

/*!
assign active intent for current user locally and to service
 */
+ (BFTask *)associateActiveIntentForCurrentUser:(PFObject *)intent;
/*!
completely disassociate active intent for current user locally and from service
 */
+ (BFTask *)disassociateActiveIntentForCurrentUser;

@end

@implementation DTCommonRequests

#pragma mark Challenge Day Methods

+ (void)likeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
  //query to remove likes
  PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kDTActivityClassKey];
  [queryExistingLikes whereKey:kDTActivityChallengeDayKey equalTo:challengeDay];
  [queryExistingLikes whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeLike];
  [queryExistingLikes whereKey:kDTActivityFromUserKey equalTo:[PFUser currentUser]];
  [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
  [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
    if (!error) {
      for (PFObject *activity in activities) {
        [activity deleteInBackground];
      }

      PFObject *likeActivity = [PFObject objectWithClassName:kDTActivityClassKey];
      [likeActivity setObject:kDTActivityTypeLike forKey:kDTActivityTypeKey];
      [likeActivity setObject:[PFUser currentUser] forKey:kDTActivityFromUserKey];
      // TODO: need to use stored intent to retrieve user to associate activity with
#warning need to use stored intent to retrieve user to associate activity with
//      [likeActivity setObject:[[challengeDay objectForKey:kDTChallengeDayIntentKey]
//                               objectForKey:kDTIntentUserKey]
//                       forKey:kDTActivityToUserKey];
      likeActivity[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
                                                                                 objectId:challengeDay.objectId];

      PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
      [likeACL setPublicReadAccess:YES];
      likeActivity.ACL = likeACL;

      [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (completionBlock) {
          completionBlock(succeeded,error);
        }
        PFQuery *query = [DTCommonRequests queryForActivitiesOnChallengeDay:challengeDay cachePolicy:kPFCachePolicyNetworkOnly];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
          if (!error) {            
            [[DTCache sharedCache] refreshCacheActivity:objects forChallengeDay:challengeDay];
          }
#warning send push notification here
        }];
      }];
    }
  }];
}

+ (void)unLikeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock
{
  PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kDTActivityClassKey];
  [queryExistingLikes whereKey:kDTActivityChallengeDayKey equalTo:challengeDay];
  [queryExistingLikes whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeLike];
  [queryExistingLikes whereKey:kDTActivityFromUserKey equalTo:[PFUser currentUser]];
  [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
  [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
    if (!error) {
      for (PFObject *activity in activities) {
        [activity deleteInBackground];
      }

      if (completionBlock) {
        completionBlock(YES,nil);
      }

      PFQuery *query = [DTCommonRequests queryForActivitiesOnChallengeDay:challengeDay cachePolicy:kPFCachePolicyNetworkOnly];
      [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
          [[DTCache sharedCache] refreshCacheActivity:objects forChallengeDay:challengeDay];
        }
#warning send push notification here
      }];
    }else {
      if(completionBlock){
        completionBlock(NO,error);
      }
    }
  }];
}

+ (void)activeDayForDate:(NSDate *)date user:(PFUser *)user
{
  [[DTCommonRequests retrieveActiveIntentForUser:user] continueWithSuccessBlock:^id(BFTask *task) {
    if (!task.error) {
      uint32_t challengeUserSeed = [DTCommonUtilities challengeUserSeedFromIntent:task.result];

      NIDINFO(@"seed: %u",challengeUserSeed);

      [PFCloud callFunctionInBackground:DTQueryActiveDay
                         withParameters:@{@"seed": @(challengeUserSeed) }
                                  block:^(PFObject *day, NSError *error) {
                                    if (!error) {
                                      NIDINFO(@"the day: %@",day);
                                      [[NSNotificationCenter defaultCenter]
                                       postNotificationName:DTChallengeDayRetrievedNotification
                                                     object:day
                                                   userInfo:nil];
                                    }else {
                                      NIDINFO("error!: %@",error.localizedDescription);
                                    }
                                  }];
    }
    return nil;
  }];
}
//looking into replacing
+ (void)requestDaysForIntent:(PFObject *)intent cachePolicy:(PFCachePolicy)cachePolicy
{
  #warning I'm not entirely sure i remember why this is a thing
  PFRelation *intentRelation = [intent relationForKey:kDTIntentChallengeDays];
  PFQuery *dayQuery = [intentRelation query];
  [dayQuery setCachePolicy:cachePolicy];
  [dayQuery findObjectsInBackgroundWithBlock:^(NSArray *days, NSError *error){
    if (!error && [days count] > 0) {
      [[DTCache sharedCache] cacheChallengeDays:days forIntent:intent];
    }else {
      NIDINFO(@"error: %@",[error localizedDescription]);
    }
  }];
}

#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnChallengeDay:(PFObject *)challengeDay cachePolicy:(PFCachePolicy)cachePolicy
{
  PFQuery *queryLikes = [PFQuery queryWithClassName:kDTActivityClassKey];
  [queryLikes whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeLike];
  [queryLikes whereKey:kDTActivityChallengeDayKey
               equalTo:[PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
                                                       objectId:challengeDay.objectId]];
  
  PFQuery *queryComments = [PFQuery queryWithClassName:kDTActivityClassKey];
  [queryComments whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeComment];
  [queryComments whereKey:kDTActivityChallengeDayKey
                  equalTo:[PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
                                                          objectId:challengeDay.objectId]];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments, nil]];
  [query setCachePolicy:cachePolicy];
  [query includeKey:kDTActivityFromUserKey];
  [query includeKey:kDTActivityToUserKey];
  
  return query;
}

+ (void)verificationActivity:(NSString *)status
{
  //add image or mapview content to this method definition
  PFObject *challengeDay = [[DTCache sharedCache] challengeDayForDate:[NSDate date] intent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
  PFObject *challenge    = [[DTCache sharedCache] challengeForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
  
  PFObject *verification = [PFObject objectWithClassName:kDTVerificationClass];
  [verification setObject:@([[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] +1)
                   forKey:kDTVerificationOrdinalKey];
  [verification setObject:[challenge objectForKey:kDTChallengeVerificationTypeKey] forKey:kDTVerificationTypeKey];
  
  //if there is a verification status entered:
  NSString *trimmedStatus = [status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if (trimmedStatus.length > 0)
  {
    [verification setObject:trimmedStatus forKey:kDTVerificationStatusContentKey];
  }
  [verification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    if (succeeded) {
      PFObject *verifyActivity = [PFObject objectWithClassName:kDTActivityClassKey];
      [verifyActivity setObject:[PFUser currentUser] forKey:kDTActivityFromUserKey];
      [verifyActivity setObject:kDTActivityTypeVerificationFinish forKey:kDTActivityTypeKey];
      verifyActivity[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:challengeDay.objectId];
      verifyActivity[kDTActivityVerificationKey] = [PFObject objectWithoutDataWithClassName:kDTVerificationClass objectId:verification.objectId];
      [verifyActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
          NIDINFO(@"verification-tick saved!");
          [challengeDay fetchInBackgroundWithBlock:^(PFObject *day, NSError *error){
            if(!error && day){
              [[DTCache sharedCache] cacheChallengeDay:day];
            }
          }];
        }else {
          NIDINFO(@"%@",[error localizedDescription]);
        }
      }];
    }else {
      NIDINFO(@"%@",[error localizedDescription]);
    }
  }];
}

#pragma mark Intent Methods
#warning need to test
+ (BFTask *)retrieveActiveIntentForUser:(PFUser *)user
{
  if ([[PFUser currentUser] isEqual:user]) {
    return [[self queryPinnedActiveIntentForCurrentUser] continueWithBlock:^id(BFTask *pinned){
      if (pinned.result) {
        return pinned.result;
      }
      else if([[DTCache sharedCache] activeIntentForUser:user] != nil) {
        return [BFTask taskWithResult:[[DTCache sharedCache] activeIntentForUser:user]];
      }
      else {
        return [self queryActiveIntentForUserFromService:user];
      }
    }];
  }else if([[DTCache sharedCache] activeIntentForUser:user] != nil) {
    return [BFTask taskWithResult:[[DTCache sharedCache] activeIntentForUser:user]];
  }else {
    return [self queryActiveIntentForUserFromService:user];
  }
}

#warning need to test
+ (BFTask *)retrieveIntentsForUser:(PFUser *)user
{
  if([[DTCache sharedCache] intentsForUser:user] != nil){
    return [BFTask taskWithResult:[[DTCache sharedCache] intentsForUser:user]];
  }
  
  PFQuery *intentQuery = [PFQuery queryWithClassName:kDTIntentClassKey];
  [intentQuery whereKey:kDTIntentUserKey equalTo:user];
  return [[intentQuery findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *intents){
    if (intents.result) {
      [[DTCache sharedCache] cacheIntents:intents.result forUser:user];
      return intents.result;
    }
    return nil;
  }];
}

+ (BFTask *)userNotLoggedIn
{
  return [BFTask taskWithError:[NSError errorWithDomain:@"kDTDomainUserNotLoggedInError" code:200 userInfo:nil]];
}

+ (BFTask *)userHasNoActiveIntent
{
  return [BFTask taskWithError:[NSError errorWithDomain:@"kDTDomainUserHasNoActiveIntent" code:-200 userInfo:nil]];
}

+ (BFTask *)unPinActiveIntent
{
  return [PFObject unpinAllObjectsInBackgroundWithName:kDTPinnedActiveIntent];
}

+ (BFTask *)unPinAndClearCache
{
  return [[DTCommonRequests unPinActiveIntent]
          continueWithSuccessBlock:^id(BFTask *task){
            [[DTCache sharedCache] clear];
            return nil;
          }];
}

+ (BFTask *)unPinAndRemoveActiveIntentFromCache
{
  return [[DTCommonRequests unPinActiveIntent]
          continueWithSuccessBlock:^id(BFTask *task){
            [[DTCache sharedCache] removeActiveIntentForCurrentUser];
            return nil;
          }];
}

+ (BFTask *)pinActiveIntentForCurrentUser:(PFObject *)intent
{
  return [intent pinInBackgroundWithName:kDTPinnedActiveIntent];
}

+ (BFTask *)pinAndCacheActiveIntent:(PFObject *)intent
{
  return [[DTCommonRequests pinActiveIntentForCurrentUser:intent]
          continueWithSuccessBlock:^id(BFTask *task){
            [[DTCache sharedCache] cacheActiveIntent:
             [[PFUser currentUser] objectForKey:kDTUserActiveIntent]
                                                user:[PFUser currentUser]];
            return nil;
          }];
}

+ (BFTask *)queryActiveIntentForUserFromService:(PFUser *)user
{
  PFQuery *intentQuery = [PFQuery queryWithClassName:kDTIntentClassKey];
  [intentQuery whereKey:kDTIntentUserKey equalTo:user];
  return [[intentQuery getFirstObjectInBackground] continueWithSuccessBlock:^id(BFTask *task){
    if (task.result) {
      [[DTCache sharedCache] cacheActiveIntent:task.result user:user];
      return task.result;
    }
    else
      return [self userHasNoActiveIntent];
  }];
}

+ (BFTask *)queryCurrentUserObjectWithActiveIntentKeyFromService
{
  //query service for intent object that the current user has
  //if there is no intent on this object then the user does not have an active challenge
  PFQuery *userQuery = [PFUser query];
  [userQuery includeKey:kDTUserActiveIntent];
  return [userQuery getObjectInBackgroundWithId:[PFUser currentUser].objectId];
}

+ (BFTask *)queryPinnedActiveIntentForCurrentUser
{
  PFQuery *query = [PFQuery queryWithClassName:kDTIntentClassKey];
  [query fromPinWithName:kDTPinnedActiveIntent];
  return [[query getFirstObjectInBackground] continueWithBlock:^id(BFTask *task){
    if (task.result){
      [[DTCache sharedCache] cacheActiveIntent:task.result user:[PFUser currentUser]];
      return task.result;
    }
    return nil;
  }];
}

+ (BFTask *)associateActiveIntentForCurrentUser:(PFObject *)intent
{
    [[PFUser currentUser] setObject:intent forKey:kDTUserActiveIntent];
    return [[[PFUser currentUser] saveInBackground] continueWithSuccessBlock:^id(BFTask *task){
      return [DTCommonRequests pinAndCacheActiveIntent:intent];
    }];
}

+ (BFTask *)disassociateActiveIntentForCurrentUser
{
  [[PFUser currentUser] removeObjectForKey:kDTUserActiveIntent];
  return [[[PFUser currentUser] saveInBackground]
          continueWithSuccessBlock:^id(BFTask *task) {
            return [DTCommonRequests unPinAndRemoveActiveIntentFromCache];
  }];
}

#pragma mark Challenge Entry/Exit

+ (BFTask *)joinChallenge:(NSString *)challengeId
{
  return [[DTCommonRequests unPinActiveIntent] continueWithSuccessBlock:^id(BFTask *join){
    return [[PFCloud callFunctionInBackground:DTJoinChallenge
                               withParameters:@{@"challenge":challengeId}]
            continueWithBlock:^id(BFTask *task){
              if (!task.error) {
                return [DTCommonRequests associateActiveIntentForCurrentUser:task.result];
              }else {
                NIDINFO("error!: %@",task.error.localizedDescription);
              }
              return nil;
            }];
  }];
}

+ (BFTask *)leaveChallenge
{
  [[[PFUser currentUser] objectForKey:kDTUserActiveIntent] setObject:@(YES) forKey:kDTIntentAccomplishedIntentKey];

  return [[[[PFUser currentUser] objectForKey:kDTUserActiveIntent] saveInBackground] continueWithSuccessBlock:^id(BFTask *task){
    return [DTCommonRequests disassociateActiveIntentForCurrentUser];
  }];
}

#pragma mark User Entry/Exit

+ (BFTask *)logoutCurrentUser
{
  return [[PFUser logOutInBackground] continueWithSuccessBlock:^id(BFTask *task){
    return [DTCommonRequests unPinAndClearCache];
  }];
}

+ (BFTask *)logInWithUserCredential:(NSString *)userCredential password:(NSString *)passwordCredential
{
  return [[PFUser logInWithUsernameInBackground:userCredential
                                       password:passwordCredential]
    continueWithSuccessBlock:^id(BFTask *login){
      if (!login.result)
        return nil;

      return [[DTCommonRequests queryCurrentUserObjectWithActiveIntentKeyFromService]
              continueWithSuccessBlock:^id(BFTask *intent){
                if (![intent.result objectForKey:kDTUserActiveIntent]) {
                  return [DTCommonRequests userHasNoActiveIntent];
                }
                return [[DTCommonUtilities isValidDateForActiveIntent:[intent.result objectForKey:kDTUserActiveIntent]]
                        continueWithSuccessBlock:^id(BFTask *validate){
                          if ([validate.result boolValue])
                            return [DTCommonRequests pinAndCacheActiveIntent:[intent.result objectForKey:kDTUserActiveIntent]];
                          else
                            return [DTCommonRequests leaveChallenge];
                        }];
      }];
  }];
}

+ (void)signUpWithEmailCredential:(NSString *)emailCredential password:(NSString *)passwordCredential user:(NSString *)userCredential
{
#warning this doesnt take into account user sessions and anonymous user behaviors -- technically this user could already have an intention maybe?
  PFUser *signUpUser = [PFUser user];
  signUpUser.username = userCredential;
  signUpUser.email    = emailCredential;
  signUpUser.password = passwordCredential;

  [[signUpUser signUpInBackground] continueWithSuccessBlock:^id(BFTask *task){
    NIDINFO(@"created a new user!");
    return nil;
  }];
}

@end
