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

- (void)incrementLikeCountForChallengeDay:(PFObject *)challengeDay;
- (void)decrementLikeCountForChallengeDay:(PFObject *)challengeDay;
- (void)setAttributesForChallengeDay:(PFObject *)challengeDay
                              likers:(NSArray *)likers
                          commenters:(NSArray *)commenters
                isLikedByCurrentUser:(BOOL)liked;
@end
