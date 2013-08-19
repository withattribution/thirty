//
//  daytodayTests.m
//  daytodayTests
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "daytodayTests.h"
#import "SRTestCase.h"

@implementation daytodayTests

- (void)setUp
{
    self.modelURL = [NSString stringWithFormat:@"DayTodayModels"];
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMath
{
    STAssertTrue(( (2+2) == 4),@"Math stopped working.");
}

@end
