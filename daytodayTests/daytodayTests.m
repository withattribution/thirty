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
    NIMaxLogLevel = NILOGLEVEL_INFO;
    userCreated = NO;
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

#pragma mark -
#pragma mark User Request Delegate

- (void) requestDidError:(NSError*)err
{
    NIDERROR(@"error! :%@:",[err localizedDescription]);
    
}

- (void) userCreatedSuccesfully:(User*)user
{
    userCreated = YES;
}

- (void) gotUser:(User*)user
{
    
}

- (void) userUpdated:(User*)user
{
    
}

- (void)testUserCreation
{
    UserRequest * req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    req.delegate = self;
    NSString *username = [[self generateUUIDString] substringWithRange:NSMakeRange(0, 15)];
    STAssertFalse(userCreated, @"user created preemptively?");
    [req createUser:username withPassword:[self generateUUIDString] additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(userCreated, @"user not created!");
}

@end
