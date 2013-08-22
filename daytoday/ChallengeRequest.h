//
//  ChallengeRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/21/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"

@protocol ChallengeRequestDelegate <D2RequestDelegate>
- (void) challengeSuccessfullyCreated;
- (void) gotChallenge;
- (void) updatedChallenge;
@end

@interface ChallengeRequest : D2Request
@property(nonatomic,weak) id <ChallengeRequestDelegate> delegate;
@end
