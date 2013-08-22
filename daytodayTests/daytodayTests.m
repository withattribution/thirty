//
//  daytodayTests.m
//  daytodayTests
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "daytodayTests.h"
#import "SRTestCase.h"

@interface Auth : NSObject
@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,strong) NSNumber* userId;
@end
@implementation Auth
@synthesize username,password, userId;

- (id)init
{
    self = [super init];
    if (self) {
        self.username = [[self uuidString] substringWithRange:NSMakeRange(0, 15)];
        self.password = [[self uuidString] substringWithRange:NSMakeRange(0, 15)];
        self.userId = [NSNumber numberWithInt:0];
    }
    return self;
}

- (NSString*) uuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef a = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *uuidString = [NSString stringWithFormat:@"%@",a];
    CFRelease(uuid);
    CFRelease(a);
    return [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

@end


@implementation daytodayTests

- (void)setUp
{
    self.modelURL = [NSString stringWithFormat:@"DayTodayModels"];
    NIMaxLogLevel = NILOGLEVEL_INFO;
    userCreated = NO;
    userUpdated = NO;
    followWorked = NO;
    authSuccess = NO;
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
    NIDINFO(@"user made! : %@",user);
    tempUser = user;
    userCreated = YES;
}

- (void) gotUser:(User*)user
{
    tempUser = user;
}

- (void) userUpdated:(User*)user
{
    userUpdated = YES;
    tempUser = user;
}

#pragma mark -
#pragma mark Authentication Request Delegate

-(void) authenticationSuccessful:(User*)user
{
    authSuccess  = YES;
    tempUser = user;
}

-(void) logoutSuccessful
{
    
}

#pragma mark -
#pragma mark Follow Request Delegate

- (void) successfullyFollowed:(Follow*)fl
{
    followWorked = YES;
}
- (void) succesfullyUnfollowed
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

-(void) testUserUpdate
{
    NSString *realname = [[self generateUUIDString] substringWithRange:NSMakeRange(0, 15)];
    UserRequest * req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    req.delegate = self;
    [req updateUserWithParameters:@{@"real_name" :realname }];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(userUpdated, @"user successfully updated");
    
    UserRequest *r1 = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    r1.delegate = self;
    [r1 getUser:tempUser.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    NIDINFO(@"temp user looks like: %@",tempUser);
    STAssertTrue([tempUser.realName isEqualToString:realname], @"didn't get out what I put in");
}

-(void) testSharedApplicationDelegate
{
    STAssertNotNil([UIApplication sharedApplication].delegate,@"delegate should exist");
    NIDINFO(@"shared application delegate looks like: %@",[[UIApplication sharedApplication].delegate class]);
}

-(void)testFlow
{
    Auth *userA = [[Auth alloc] init];
    Auth *userB = [[Auth alloc] init];
    Auth *userC = [[Auth alloc] init];
    UserRequest *req = [[UserRequest alloc] initWithContext:self.managedObjectContext];

    req.delegate = self;
    [req createUser:userA.username withPassword:userA.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    userA.userId = tempUser.userId;
    
    AuthenticationRequest* req1 = [[AuthenticationRequest alloc] initWithContext:self.managedObjectContext];
    req1.delegate = self;
    [req1 logoutDevice];
    
    [req createUser:userB.username withPassword:userB.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    userB.userId = tempUser.userId;
    [req1 logoutDevice];
    
    [req createUser:userC.username withPassword:userC.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    userC.userId = tempUser.userId;
    [req1 logoutDevice];
    
    [req1 loginUser:userA.username withPassword:userA.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(authSuccess, @"authentication was unusccessful");
    
    FollowRequest* fr = [[FollowRequest alloc] initWithContext:self.managedObjectContext];
    fr.delegate = self;
    [fr followUser:userB.userId];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    followWorked = NO;
    authSuccess = NO;
    [req1 loginUser:userB.username withPassword:userB.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    [fr followUser:userA.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    followWorked = NO;
    [req1 loginUser:userC.username withPassword:userC.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    [fr followUser:userA.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    
    
}


@end
