//
//  ChallengeRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/21/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
#import "Challenge.h"

@protocol ChallengeRequestDelegate <D2RequestDelegate>
- (void) challengeSuccessfullyCreated:(Challenge*)challenge;
- (void) gotChallenge:(Challenge*)challenge;
- (void) updatedChallenge:(Challenge*)challenge;
@end

@interface ChallengeRequest : D2Request
@property(nonatomic,weak) id <ChallengeRequestDelegate> delegate;

- (void) createChallenge:(NSDictionary*)params;
- (void) updateChallenge:(NSDictionary*)params;
- (void) getChallenge:(NSNumber*)challengeId;

@end
