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

#pragma mark - Comment Caching Methods
#warning not implemented so comment count cache is off -- interface for deleting comments does not exist yet!
- (void)incrementCommentCountForChallengeDay:(PFObject *)challengeDay;
- (void)decrementCommentCountForChallengeDay:(PFObject *)challengeDay;

#pragma mark - Like Caching Methods

- (void)incrementLikeCountForChallengeDay:(PFObject *)challengeDay;
- (void)decrementLikeCountForChallengeDay:(PFObject *)challengeDay;


@end
