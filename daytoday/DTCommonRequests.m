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
  uint32_t challengeUserSeed;
  
  if ([[DTCache sharedCache] activeIntentForUser:user] != nil) {
    challengeUserSeed = [DTCommonUtilities challengeUserSeedFromIntent:[[DTCache sharedCache] activeIntentForUser:user]];
  }else {
    challengeUserSeed = [DTCommonUtilities challengeUserSeedFromIntent:[[user objectForKey:kDTUserActiveIntent] fetchIfNeeded]];
  }

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

+ (void)requestDaysForIntent:(PFObject *)intent cachePolicy:(PFCachePolicy)cachePolicy
{
  PFRelation *intentRelation = [intent relationforKey:kDTIntentChallengeDays];
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

+ (void)activeIntent:(PFObject *)intent
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
}

+ (void)queryActiveIntent:(PFUser *)user
{
  PFQuery *userQuery = [PFUser query];
  [userQuery includeKey:kDTUserActiveIntent];
  [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error){
    if (!error && obj) {
      NIDINFO(@"the obj: %@",[obj objectForKey:kDTUserActiveIntent]);
      [[DTCache sharedCache] cacheActiveIntent:[obj objectForKey:kDTUserActiveIntent] user:user];
    }else {
      NIDINFO(@"active intent query failed: %@", [error localizedDescription]);
    }
  }];
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
  [PFCloud callFunctionInBackground:DTJoinChallenge
                     withParameters:@{@"challenge":challengeId}
                              block:^(PFObject *intent, NSError *error) {
                                if (!error && intent) {
                                  NIDINFO(@"success!: %@",intent);
                                  [DTCommonRequests activeIntent:intent];
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

@end
