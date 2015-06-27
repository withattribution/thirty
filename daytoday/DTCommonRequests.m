//
//  DTRequests.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonRequests.h"
#import "MurmurHash.h"

@implementation DTCommonRequests

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

#pragma mark Challenge Day Methods

+ (void)activeDayForDate:(NSDate *)date user:(PFUser *)user
{
  [[DTCommonRequests retrieveIntentForUser:user] continueWithSuccessBlock:^id(BFTask *task) {
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

+ (void)requestDaysForIntent:(PFObject *)intent cachePolicy:(PFCachePolicy)cachePolicy
{
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

#pragma mark Itents for User

+ (void)setCurrentUserActiveIntent:(PFObject *)intent
{
  //only a valid call if user is logged in
  if ([PFUser currentUser])
  {
      [[PFUser currentUser] setObject:intent forKey:kDTUserActiveIntent];
      [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded) {
          NIDINFO(@"updated active intent: %@",[[PFUser currentUser] objectForKey:kDTUserActiveIntent]);
          [[DTCache sharedCache] cacheActiveIntent:[[PFUser currentUser] objectForKey:kDTUserActiveIntent]
                                              user:[PFUser currentUser]];
        }
        else {
          NIDINFO(@"user failed to set active intent: %@",[error localizedDescription]);
        }
      }];
  }
#warning should disable join challenge button unless user is logged in -- or if not logged in send to login/register vc
}

+ (BFTask *)queryIntentFromPinForUser:(PFUser *)user
{
  return nil;
}

//try to retrieve intent for user
//case user logged in -- try query from local pin
//otherwise query cloud
//case user not logged in -- just query cloud code

+ (BFTask *)retrieveIntentForUser:(PFUser *)user {
  BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
          NIDINFO(@"jesus christ");
  if ([[PFUser currentUser] isEqual:user]) {
    PFQuery *query = [PFQuery queryWithClassName:kDTIntentClassKey];
    [query fromPinWithName:kDTPinnedActiveIntent];
    [[query getFirstObjectInBackground] continueWithBlock:^id(BFTask *task){
      if (!task.error) {
        [[DTCache sharedCache] cacheActiveIntent:task.result user:user];
        [tcs setResult:task.result];
      }else {
#warning this doesn't look up other users dumb ass
        [[self queryActiveIntentForUser:user] continueWithSuccessBlock:^id(BFTask *ts){
          NIDINFO(@"did you find it or what?: %@",ts.result);
          return ts;
        }];
        //cuz this is an error not found then try the query
//        PFQuery *userQuery = [PFUser query];
//        [userQuery includeKey:kDTUserActiveIntent];
//
//        [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error){
//          if (!error && obj) {
//            //      NIDINFO(@"the obj: %@",[obj objectForKey:kDTUserActiveIntent]);
//            [[DTCache sharedCache] cacheActiveIntent:[obj objectForKey:kDTUserActiveIntent] user:user];
//            [tcs setResult:obj];
//          }else {
//            NIDINFO(@"active intent query failed: %@", [error localizedDescription]);
//            [tcs setError:error];
//          }
//        }];
      }
      return nil;
    }];
  } else {
#warning add ability to query other users
    [[self queryActiveIntentForUser:user] continueWithSuccessBlock:^id(BFTask *ts){
      NIDINFO(@"did you find it or what?: %@",ts.result);
      return ts;
    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:[PFUser class]];

  }
//  else {
//    PFQuery *userQuery = [PFUser query];
//    [userQuery includeKey:kDTUserActiveIntent];
//
//    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error){
//      if (!error && obj) {
//        //      NIDINFO(@"the obj: %@",[obj objectForKey:kDTUserActiveIntent]);
//        [[DTCache sharedCache] cacheActiveIntent:[obj objectForKey:kDTUserActiveIntent] user:user];
//        [tcs setResult:obj];
//      }else {
//        NIDINFO(@"active intent query failed: %@", [error localizedDescription]);
//        [tcs setError:error];
//      }
//    }];
//  }
  return tcs.task;
}

+ (BFTask *)queryActiveIntentForUser:(PFUser *)user
{
  BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
  //If the active intent query is for the current user then we should have one that's been pinned
  //to the local data store, if there isn't one in the local data store then we should query the
  //cloud store, when we retrieve it -- dunk it in the local memory cache

//  if ([[PFUser currentUser] isEqual:user]) {
//    PFQuery *query = [PFQuery queryWithClassName:kDTIntentClassKey];
//    [query fromPinWithName:kDTPinnedActiveIntent];
//    [[query findObjectsInBackground] continueWithBlock:^id(BFTask *task) {
//      if (!task.error) {
//        NIDINFO(@"the result: %@",[task.result firstObject]);
//        [[DTCache sharedCache] cacheActiveIntent:[task.result firstObject] user:user];
//      }
//      return nil;
//    }];
//  }
//  else {
    PFQuery *userQuery = [PFUser query];
    [userQuery includeKey:kDTUserActiveIntent];
//    [[userQuery getFirstObjectInBackground] continueWithSuccessBlock:^id(BFTask *task){
//      return nil;
//    }];
  
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error){
      if (!error && obj) {

//      NIDINFO(@"the obj: %@",[obj objectForKey:kDTUserActiveIntent]);
        [[DTCache sharedCache] cacheActiveIntent:[obj objectForKey:kDTUserActiveIntent] user:user];
        [tcs setResult:[obj valueForKey:kDTUserActiveIntent]];
      }else {
        NIDINFO(@"active intent query failed: %@", [error localizedDescription]);
        [tcs setError:error];
      }
    }];
//  }
  return tcs.task;
}

+ (void)queryIntentsForUser:(PFUser *)user
{
  PFQuery *intentQuery = [PFQuery queryWithClassName:kDTIntentClassKey];
  [intentQuery whereKey:kDTIntentUserKey equalTo:user];
  [intentQuery findObjectsInBackgroundWithBlock:^(NSArray *intents, NSError *error){
    if (!error && [intents count] > 0) {
      [[DTCache sharedCache] cacheIntents:intents forUser:user];
    }else {
      NIDINFO(@"error: %@",[error localizedDescription]);
    }
  }];
}

#pragma mark Intent Methods

+ (void)joinChallenge:(NSString *)challengeId
{
#warning needs to check if there is a current unfinished intent and deal with user choice
#warning because after this the intent is forcibly switched
  //There can only be one!
  [PFObject unpinAllObjectsInBackgroundWithName:kDTPinnedActiveIntent];

  [PFCloud callFunctionInBackground:DTJoinChallenge
                     withParameters:@{@"challenge":challengeId}
                              block:^(PFObject *intent, NSError *error) {
                                if (!error && intent) {
                                  NIDINFO(@"success!: %@",intent);
                                  //save to local data store
                                  [intent pinInBackgroundWithName:kDTPinnedActiveIntent];

                                  [DTCommonRequests setCurrentUserActiveIntent:intent];
                                  [DTCommonRequests requestDaysForIntent:intent cachePolicy:kPFCachePolicyNetworkOnly];
                                }else {
                                  NIDINFO("error!: %@",error.localizedDescription);
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

#pragma mark User Entry/Exit

+ (void)logoutCurrentUser
{
  [[PFUser logOutInBackground] continueWithBlock:^id(BFTask *task){
    if (!task.error) {

      //release cache and unpin all objects
      [[DTCache sharedCache] clear];
      [[PFObject unpinAllObjectsInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *ts){

        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logged Out"
                                                              message:@"you can't do much of anything now :("
                                                             delegate:nil
                                                    cancelButtonTitle:@":) :) :)"
                                                    otherButtonTitles:nil];
        [logoutAlert show];
      
        return nil;
      }];
    }
    else {
      NIDINFO(@"%@",[task.error localizedDescription]);
    }
    return nil;
  }];
}

+ (void)logInWithUserCredential:(NSString *)userCredential password:(NSString *)passwordCredential
{
  [PFUser logInWithUsernameInBackground:userCredential password:passwordCredential
                                  block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                      NIDINFO(@"logged in withIntent: %d",[[user objectForKey:kDTUserActiveIntent] isDataAvailable]);
                                      if ([user objectForKey:kDTUserActiveIntent]) {
                                        [[DTCommonRequests retrieveIntentForUser:user] continueWithSuccessBlock:^id(BFTask *task){
                                          if (!task.error) {
                                            NIDINFO(@"the result: %@",task.result);
                                          }
                                          return nil;
                                        }];
                                      }
                                    } else {
                                      NIDINFO(@"ERR: %@",[error localizedDescription]);
                                    }
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
    if (!task.error) {
      NIDINFO(@"created a new user!");
    }else {
      NIDINFO(@"SignUp ERROR: %@",[task.error localizedDescription]);
    }
    return nil;
  }];
}

@end
