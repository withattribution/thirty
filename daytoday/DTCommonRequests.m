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

+ (BFTask *)clearLocalStorage;

+ (BFTask *)unpinActiveIntent;
+ (BFTask *)unpinActiveIntentAndRemoveFromCache;

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

+ (BFTask *)queryChallengeDaysFromServiceForIntent:(PFObject *)intent;
+ (BFTask *)queryChallengeDaysFromLocalStoreForActiveIntent:(PFObject *)intent;

+ (BFTask *)pinAndCacheChallengeDaysForCurrentUser:(NSArray *)days;
+ (BFTask *)unpinAndRemoveFromCacheChallengeDaysForCurrentUser;
+ (BFTask *)unpinChallengeDaysForCurrentUser;

@end

@implementation DTCommonRequests

#pragma mark Challenge Day Methods

+ (BFTask *)retrieveActiveChallengeDayForDate:(NSDate *)date user:(PFUser *)user
{
#warning a possible way to optimize this might be to sort the pinned challenge days by ordinal and then translate the active hash to ordinal and lookup the active day locally for current users -- and only hit the service directly for other users (but not now)
  return [[DTCommonRequests retrieveActiveIntentForUser:user]
          continueWithSuccessBlock:^id(BFTask *task){
            uint32_t challengeUserSeed = [DTCommonUtilities challengeUserSeedFromIntent:task.result];
            NIDINFO(@"seed: %u",challengeUserSeed);
            return [[PFCloud callFunctionInBackground:DTQueryActiveDay
                                       withParameters:@{@"seed": @(challengeUserSeed) }]
                    continueWithBlock:^id(BFTask *day){
                      if (!day.error) {
                        NIDINFO(@"the day: %@",day.result);
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:DTChallengeDayRetrievedNotification
                         object:day.result
                         userInfo:nil];
                        return day.result;
                      }
                      NIDINFO("error!: %@",day.error.localizedDescription);
                      return nil;
                    }];
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

+ (BFTask *)retrieveDaysForIntent:(PFObject *)intent
{
  //if the intent is NOT the current active intent
  //then try the local cache and
  //then just hit the service
  if(![intent.objectId isEqualToString:[[[PFUser currentUser] objectForKey:kDTUserActiveIntent] objectId]]){
    NSArray *days = [[DTCache sharedCache] challengeDaysForIntent:intent];
    if ([days count] > 0) {
      return [BFTask taskWithResult:days];
    }else{
      return [DTCommonRequests queryChallengeDaysFromServiceForIntent:intent];
    }
  }
  //query pinned days, then cache, then try service
  return [[DTCommonRequests queryChallengeDaysFromLocalStoreForActiveIntent:intent]
          continueWithBlock:^id(BFTask *pinned){
            if ([pinned.result count] == 0) {
              NSArray *days = [[DTCache sharedCache] challengeDaysForIntent:intent];
              if ([days count] > 0) {
                return [BFTask taskWithResult:days];
              }else{
                return [DTCommonRequests queryChallengeDaysFromServiceForIntent:intent];
              }
            }
            return pinned.result;
          }];
}

+ (BFTask *)queryChallengeDaysFromServiceForIntent:(PFObject *)intent
{
  PFRelation *intentRelation = [intent relationForKey:kDTIntentChallengeDays];
  PFQuery *dayQuery = [intentRelation query];
  return [[dayQuery findObjectsInBackground] continueWithBlock:^id(BFTask *days){
    if([intent.objectId isEqualToString:[[[PFUser currentUser] objectForKey:kDTUserActiveIntent] objectId]]){
      return [DTCommonRequests pinAndCacheChallengeDaysForCurrentUser:days.result];
    }else {
      [[DTCache sharedCache] cacheChallengeDays:days.result forIntent:intent];
    }
    return days.result;
  }];
}

+ (BFTask *)queryChallengeDaysFromLocalStoreForActiveIntent:(PFObject *)intent
{
  PFQuery *dayQuery = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
  [dayQuery fromPinWithName:kDTPinnedActiveChallengeDays];
  return [[dayQuery findObjectsInBackground] continueWithBlock:^id(BFTask *days){
    [[DTCache sharedCache] cacheChallengeDays:days.result forIntent:intent];
    return days.result;
  }];
}

+ (BFTask *)pinAndCacheChallengeDaysForCurrentUser:(NSArray *)days
{
  return [[PFObject pinAllInBackground:days withName:kDTPinnedActiveChallengeDays]
          continueWithSuccessBlock:^id(BFTask *pinned){
            [[DTCache sharedCache] cacheChallengeDays:days
                                            forIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
            return [BFTask taskWithResult:days];
  }];
}

+ (BFTask *)unpinAndRemoveFromCacheChallengeDaysForCurrentUser
{
  return [[DTCommonRequests unpinChallengeDaysForCurrentUser]
          continueWithSuccessBlock:^id(BFTask *task){
            [[DTCache sharedCache] removeChallengeDaysForCurrentUser];
            return nil;
  }];
}

+ (BFTask *)unpinChallengeDaysForCurrentUser
{
  return [PFObject unpinAllObjectsInBackgroundWithName:kDTPinnedActiveChallengeDays];
}

#pragma mark Activities on Challenge Day

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

+ (BFTask *)unpinActiveIntent
{
  return [PFObject unpinAllObjectsInBackgroundWithName:kDTPinnedActiveIntent];
}

+ (BFTask *)clearLocalStorage
{
  return [[DTCommonRequests unpinAndRemoveFromCacheChallengeDaysForCurrentUser]
            continueWithSuccessBlock:^id(BFTask *task){
              return [[DTCommonRequests unpinActiveIntent]
                      continueWithSuccessBlock:^id(BFTask *task){
                        [[DTCache sharedCache] clear];
                        return nil;
              }];
          }];
}

+ (BFTask *)unpinActiveIntentAndRemoveFromCache
{
  return [[DTCommonRequests unpinActiveIntent]
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
            return [DTCommonRequests unpinActiveIntentAndRemoveFromCache];
  }];
}

#pragma mark Challenge Entry/Exit

+ (BFTask *)joinChallenge:(NSString *)challengeId
{
  return [[DTCommonRequests unpinActiveIntent] continueWithSuccessBlock:^id(BFTask *join){
    return [[PFCloud callFunctionInBackground:DTJoinChallenge
                               withParameters:@{@"challenge":challengeId}]
            continueWithBlock:^id(BFTask *intent){
              if (!intent.error) {
                return [[DTCommonRequests queryChallengeDaysFromServiceForIntent:intent.result]
                        continueWithBlock:^id(BFTask *days){
                          if (!days.error) {
                            return [[DTCommonRequests pinAndCacheChallengeDaysForCurrentUser:days.result]
                                    continueWithSuccessBlock:^id(BFTask *task){
                                      return [DTCommonRequests associateActiveIntentForCurrentUser:intent.result];
                                    }];
                          }
                          NIDINFO("error!: %@",days.error.localizedDescription);
                          return days.error;
                        }];
              }
              NIDINFO("error!: %@",intent.error.localizedDescription);
              return intent.error;
            }];
  }];
}

+ (BFTask *)leaveChallenge
{
  [[[PFUser currentUser] objectForKey:kDTUserActiveIntent] setObject:@(YES) forKey:kDTIntentAccomplishedIntentKey];

  return [[[[PFUser currentUser] objectForKey:kDTUserActiveIntent] saveInBackground] continueWithSuccessBlock:^id(BFTask *task){
    return [[DTCommonRequests unpinAndRemoveFromCacheChallengeDaysForCurrentUser] continueWithSuccessBlock:^id(BFTask *task){
      return [DTCommonRequests disassociateActiveIntentForCurrentUser];
    }];
  }];
}

#pragma mark User Entry/Exit

+ (BFTask *)logoutCurrentUser
{
  return [[PFUser logOutInBackground] continueWithSuccessBlock:^id(BFTask *task){
    return [DTCommonRequests clearLocalStorage];
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
              continueWithSuccessBlock:^id(BFTask *user){
                if (![user.result objectForKey:kDTUserActiveIntent]) {
                  return [DTCommonRequests userHasNoActiveIntent];
                }
                return [[DTCommonUtilities isValidDateForActiveIntent:[user.result objectForKey:kDTUserActiveIntent]]
                        continueWithSuccessBlock:^id(BFTask *validate){
                          if ([validate.result boolValue])
                            return [[DTCommonRequests pinAndCacheActiveIntent:[user.result objectForKey:kDTUserActiveIntent]] continueWithSuccessBlock:^id(BFTask *pinned){
                              NIDINFO(@"the pinned intent: %@",[user.result objectForKey:kDTUserActiveIntent]);
                              return [DTCommonRequests retrieveDaysForIntent:[user.result objectForKey:kDTUserActiveIntent]];
                            }];
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
