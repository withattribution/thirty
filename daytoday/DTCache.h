//
//  DTCache.h
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCache : NSObject

+ (id)sharedCache;
- (void)clear;

- (NSDictionary *)attributesForChallengeDay:(PFObject *)challengeDay;
- (void)setAttributesForChallengeDay:(PFObject *)challengeDay
                              likers:(NSArray *)likers
                          commenters:(NSArray *)commenters
                isLikedByCurrentUser:(BOOL)liked;

- (void)refreshCacheActivity:(NSArray *)activities forChallengeDay:(PFObject *)challengeDay;

#pragma mark - Challenge For Intent

- (void)cacheChallenge:(PFObject *)challenge forIntent:(PFObject *)intent;
- (PFObject *)challengeForIntent:(PFObject *)intent;

#pragma mark - ChallengeDay Verification Cache

- (void)refreshVerificationActivity:(PFObject *)verification forChallengeDay:(PFObject *)challengeDay;

#pragma mark - Active Challenge Day

- (PFObject *)cachedActiveDayForDate:(NSDate *)date;
- (void)cacheChallengeDay:(PFObject *)challengeDay;

#pragma mark - Challenge Days For Intent

- (PFObject *)challengeDayForDate:(NSDate *)date intent:(PFObject *)intent;

- (NSArray *)challengeDaysForIntent:(PFObject *)intent;
- (void)cacheChallengeDays:(NSArray *)days forIntent:(PFObject *)intent;

#pragma mark - Intents for User

- (void)cacheActiveIntent:(PFObject *)intent user:(PFUser *)user;
- (PFObject *)activeIntentForUser:(PFUser *)user;

- (NSArray *)intentsForUser:(PFUser *)user;
- (void)cacheIntent:(PFObject *)intent forUser:(PFUser *)user;
- (void)cacheIntents:(NSArray *)intents forUser:(PFUser *)user;

#pragma mark - Comment And Like Get Methods

- (NSNumber *)likeCountForChallengeDay:(PFObject *)challengeDay;
- (NSNumber *)commentCountForChallengeDay:(PFObject *)challengeDay;
- (NSArray *)likersForChallengeDay:(PFObject *)challengeDay;
- (NSArray *)commentersForChallengeDay:(PFObject *)challengeDay;

- (void)setChallengeDayIsLikedByCurrentUser:(PFObject *)challengeDay liked:(BOOL)liked;
- (BOOL)isChallengeDayLikedByCurrentUser:(PFObject *)challengeDay;

#pragma mark - Comment Caching Methods

- (void)incrementCommentCountForChallengeDay:(PFObject *)challengeDay;
- (void)decrementCommentCountForChallengeDay:(PFObject *)challengeDay;

#pragma mark - Like Caching Methods

- (void)incrementLikeCountForChallengeDay:(PFObject *)challengeDay;
- (void)decrementLikeCountForChallengeDay:(PFObject *)challengeDay;

@end
