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
      [likeActivity setObject:[[challengeDay objectForKey:kDTChallengeDayIntentKey]
                               objectForKey:kDTIntentUserKey]
                       forKey:kDTActivityToUserKey];
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

+ (void)activeDayForDate:(NSDate *)date
{
  uint32_t challengeUserSeed = [[[NSUserDefaults standardUserDefaults] objectForKey:kDTChallengeUserSeed] unsignedIntValue];
  
  [PFCloud callFunctionInBackground:DTQueryActiveDay
                     withParameters:@{@"seed": @(challengeUserSeed) }
                              block:^(PFObject *day, NSError *error) {
                                if (!error) {
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
  PFQuery *dayQuery = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
  [dayQuery whereKey:kDTChallengeDayIntentKey equalTo:intent];
  [dayQuery setCachePolicy:cachePolicy];
  [dayQuery findObjectsInBackgroundWithBlock:^(NSArray *days, NSError *error){
    if (!error && [days count] > 0) {
      [[DTCache sharedCache] cacheChallengeDays:days forIntent:intent];
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
                              block:^(NSDictionary *challengeDictionary, NSError *error) {
                                if (!error && challengeDictionary) {
//                                  for (NSString *key in [challengeDictionary allKeys]) {
//                                    NIDINFO(@"obj key: %@ and object: %@",key, [challengeDictionary objectForKey:key]);
//                                  }
                                [[DTCache sharedCache] cacheChallengeDays:[challengeDictionary objectForKey:@"days"] forIntent:[challengeDictionary objectForKey:@"intent"]];
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
