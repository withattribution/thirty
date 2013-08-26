//
//  daytodayTests.h
//  daytodayTests
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SRTestCase.h"
#import "NIDebuggingTools.h"
#import "UserRequest.h"
#import "AuthenticationRequest.h"
#import "FollowRequest.h"
#import "ChallengeRequest.h"
#import "IntentRequest.h"
#import "TickRequest.h"
#import "LikeRequest.h"
#import "CommentRequest.h"

@interface daytodayTests : SRTestCase <UserRequestDelegate,
    AuthenticationRequestDelegate,
    FollowRequestDelegate,
    ChallengeRequestDelegate,
    IntentRequestDelegate, TickRequestDelegate, LikeRequestDelegate,CommentRequestDelegate>
{
    BOOL userCreated;
    BOOL userUpdated;
    User* tempUser;
    Challenge* tempChallenge;
    Intent* tempIntent;
    ChallengeDay* tempChallengeDay;
    Comment* tempComment;
    BOOL followWorked;
    BOOL authSuccess;
    BOOL challengeCreated;
    BOOL intentCreated;
    BOOL tickCreated;
    BOOL likeSuccess;
    BOOL commentSuccess;
    BOOL commentDeleted;
}
@end
