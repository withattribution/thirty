//
//  DTRequests.h
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommonRequests : NSObject

+ (void)likeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unLikeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)activeDayForDate:(NSDate *)date;

+ (void)requestDaysForIntent:(PFObject *)intent cachePolicy:(PFCachePolicy)cachePolicy;

+ (void)joinChallenge:(NSString *)challengeId;

#pragma mark Intents for User
+ (void)queryIntentsForUser:(PFUser *)user;

+ (PFQuery *)queryForActivitiesOnChallengeDay:(PFObject *)challengeDay cachePolicy:(PFCachePolicy)cachePolicy;

@end
