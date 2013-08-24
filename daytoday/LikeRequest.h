//
//  LikeRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
#import "Like+D2D.h"
#import "User+D2D.h"
#import "ChallengeDay+D2D.h"

@protocol LikeRequestDelegate <D2RequestDelegate>
- (void) successfullyLiked:(Like*)like;
- (void) successfullyUnliked;
@end

@interface LikeRequest : D2Request
- (void) like:(ChallengeDay*)cd fromUser:(User*)user;
- (void) unlike:(ChallengeDay*)cd fromUser:(User*)user;
- (void) unlike:(Like*)like;
@end
