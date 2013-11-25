//
//  DTRequests.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonRequests.h"

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
            NSMutableArray *likers = [NSMutableArray array];
            NSMutableArray *commenters = [NSMutableArray array];
            
            BOOL isLikedByCurrentUser = NO;

            for (PFObject *activity in objects) {
              if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeComment]
                  && [activity objectForKey:kDTActivityFromUserKey])
              {
                [commenters addObject:[activity objectForKey:kDTActivityFromUserKey]];
              }else if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike]
                  && [activity objectForKey:kDTActivityFromUserKey])
              {
                [likers addObject:[activity objectForKey:kDTActivityFromUserKey]];
              }
              if ([[[activity objectForKey:kDTActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]
                  && [[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike])
              {
                isLikedByCurrentUser = YES;
              }
            }
            [[DTCache sharedCache] setAttributesForChallengeDay:challengeDay
                                                         likers:likers
                                                     commenters:commenters
                                           isLikedByCurrentUser:isLikedByCurrentUser];
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
            NSMutableArray *likers = [NSMutableArray array];
            NSMutableArray *commenters = [NSMutableArray array];

            BOOL isLikedByCurrentUser = NO;

            for (PFObject *activity in objects) {
              if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeComment]
                  && [activity objectForKey:kDTActivityFromUserKey])
              {
                [commenters addObject:[activity objectForKey:kDTActivityFromUserKey]];
              }else if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike]
                  && [activity objectForKey:kDTActivityFromUserKey])
              {
                [likers addObject:[activity objectForKey:kDTActivityFromUserKey]];
              }
              if ([[[activity objectForKey:kDTActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]
                  && [[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike])
              {
                isLikedByCurrentUser = YES;
              }
            }
            [[DTCache sharedCache] setAttributesForChallengeDay:challengeDay
                                                         likers:likers
                                                     commenters:commenters
                                           isLikedByCurrentUser:isLikedByCurrentUser];
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

#pragma mark Activities 

+(PFQuery *)queryForActivitiesOnChallengeDay:(PFObject *)challengeDay cachePolicy:(PFCachePolicy)cachePolicy
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
