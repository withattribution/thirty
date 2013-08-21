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

@interface daytodayTests : SRTestCase <UserRequestDelegate>
{
    BOOL userCreated;
}
@end
