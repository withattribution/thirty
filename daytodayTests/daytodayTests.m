//
//  daytodayTests.m
//  daytodayTests
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "daytodayTests.h"
#import "SRTestCase.h"
#import "NSDate+SR.h"

#define kWaitTimeForRequest 0.4f

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
    challengeCreated = NO;
    intentCreated = NO;
    tempIntent = nil;
    tickCreated = NO;
    likeSuccess = NO;
    commentSuccess = NO;
    commentDeleted = NO;
    profileReturned = NO;
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
    //NIDINFO(@"user made! : %@",user);
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

#pragma mark -
#pragma mark Challenge Request Delegate
- (void) challengeSuccessfullyCreated:(Challenge*)challenge
{
    challengeCreated = YES;
    tempChallenge = challenge;
}
- (void) gotChallenge:(Challenge*)challenge
{
    
}
- (void) updatedChallenge:(Challenge*)challenge
{
    
}

#pragma mark -
#pragma mark Intent Request Delegate
- (void) createdIntent:(Intent*)challenge
{
    intentCreated = YES;
    if( tempIntent == nil )
        tempIntent = challenge;
}

- (void) deletedIntent:(Intent*)challenge
{
    
}

#pragma mark - 
#pragma mark Tick Request Delegate
- (void) tickAccepted:(ChallengeDay*)cd andTick:(Tick*)t
{
    tickCreated = YES;
    tempChallengeDay = cd;
}

#pragma mark -
#pragma mark Like Request Delegate
- (void) successfullyLiked:(Like*)like
{
    likeSuccess = YES;
}
- (void) successfullyUnliked
{
    
}

#pragma mark -
#pragma mark Comment Request Delegate
- (void) createdComment:(Comment*)comment
{
    commentSuccess = YES;
    tempComment = comment;
}
- (void) deletedComment
{
    commentDeleted = YES;
}

#pragma mark -
#pragma mark Profile Request Delegate

-(void) gotProfile:(NSDictionary*)dict
{
    profileReturned = YES;
}

#pragma mark -

- (void)testUserCreation
{
    UserRequest * req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    req.delegate = self;
    NSString *username = [[self generateUUIDString] substringWithRange:NSMakeRange(0, 15)];
    STAssertFalse(userCreated, @"user created preemptively?");
    [req createUser:username withPassword:[self generateUUIDString] additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(userCreated, @"user not created!");
}

-(void) testUserUpdate
{
    NSString *realname = [[self generateUUIDString] substringWithRange:NSMakeRange(0, 15)];
    UserRequest * req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    req.delegate = self;
    [req updateUserWithParameters:@{@"real_name" :realname }];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(userUpdated, @"user successfully updated");
    
    UserRequest *r1 = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    r1.delegate = self;
    [r1 getUser:tempUser.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    //NIDINFO(@"temp user looks like: %@",tempUser);
    STAssertTrue([tempUser.realName isEqualToString:realname], @"didn't get out what I put in");
}

-(void) testSharedApplicationDelegate
{
    STAssertNotNil([UIApplication sharedApplication].delegate,@"delegate should exist");
    //NIDINFO(@"shared application delegate looks like: %@",[[UIApplication sharedApplication].delegate class]);
}

-(void)testImageUpload
{
    Auth *userA = [[Auth alloc] init];
    UserRequest *req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
    req.delegate = self;
    [req createUser:userA.username withPassword:userA.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    userA.userId = tempUser.userId;
    NSString* turtlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Two-Headed-Turtle1" ofType:@"jpg"];
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:turtlePath isDirectory:NO],@"file not where it's supposed to be!");
    UIImage *turtleImage = [UIImage imageWithContentsOfFile:turtlePath];
    NSData *imageData = UIImageJPEGRepresentation(turtleImage, 0.5);
    STAssertNotNil(imageData, @"image is nil");
    NSMutableURLRequest *req1 = [req.client multipartFormRequestWithMethod:@"POST" path:@"/user" parameters:@{@"auth": req.identifier} constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"Two-Headed-Turtle1.jpg" mimeType:@"image/jpg"];
    }];
    
    __block NSDictionary* jsonDict = nil;
    
    AFJSONRequestOperation *jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req1 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        jsonDict = (NSDictionary*)JSON;
        NIDINFO(@"json dictionary looks like: %@",jsonDict);
        STAssertNotNil([jsonDict valueForKey:@"success"],@"success wasn't a thing that happened");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        STAssertFalse(YES, @"if this gets hit, there was a failure");
    }];
    [req.client enqueueHTTPRequestOperation:jrequest];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];

    
}

-(void)testFlow
{
    Auth *userA = [[Auth alloc] init];
    Auth *userB = [[Auth alloc] init];
    Auth *userC = [[Auth alloc] init];
    UserRequest *req = [[UserRequest alloc] initWithContext:self.managedObjectContext];

    req.delegate = self;
    [req createUser:userA.username withPassword:userA.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    userA.userId = tempUser.userId;
    
    AuthenticationRequest* req1 = [[AuthenticationRequest alloc] initWithContext:self.managedObjectContext];
    req1.delegate = self;
    [req1 logoutDevice];
    
    [req createUser:userB.username withPassword:userB.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    userB.userId = tempUser.userId;
    [req1 logoutDevice];
    
    [req createUser:userC.username withPassword:userC.password additionalParameters:nil];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    userC.userId = tempUser.userId;
    [req1 logoutDevice];
    
    [req1 loginUser:userA.username withPassword:userA.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(authSuccess, @"authentication was unusccessful");
    
    FollowRequest* fr = [[FollowRequest alloc] initWithContext:self.managedObjectContext];
    fr.delegate = self;
    [fr followUser:userB.userId];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    followWorked = NO;
    authSuccess = NO;
    [req1 loginUser:userB.username withPassword:userB.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [fr followUser:userA.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    followWorked = NO;
    [req1 loginUser:userC.username withPassword:userC.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [fr followUser:userA.userId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(followWorked, @"follow didn't go through successfully?");
    [req1 logoutDevice];
    
    [req1 loginUser:userA.username withPassword:userA.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    ChallengeRequest *cr = [[ChallengeRequest alloc] initWithContext:self.managedObjectContext];
    cr.delegate = self;
    NSDictionary* challengeDict = @{ @"name": self.generateUUIDString, @"description" : self.generateUUIDString,
                                     @"duration": self.generateNumber, @"frequency":self.generateNumber};
    [cr createChallenge:challengeDict];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(challengeCreated, @"challenge not created successfully");
    
    
    IntentRequest* ir = [[IntentRequest alloc] initWithContext:self.managedObjectContext];
    ir.delegate = self;
    [ir createIntent:@{ @"challenge" : tempChallenge.challengeId }];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(intentCreated, @"intent not created");
    [req1 logoutDevice];
    intentCreated = NO;
    
    [req1 loginUser:userB.username withPassword:userB.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [ir createIntent:@{@"challenge": tempChallenge.challengeId}];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(intentCreated, @"intent not created");
    [req1 logoutDevice];
    [req1 loginUser:userA.username withPassword:userA.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    TickRequest* tr = [[TickRequest alloc] initWithContext:self.managedObjectContext];
    tr.delegate = self;
    STAssertNotNil(tempIntent, @"intent shouldn't be nil here");
    STAssertNotNil(tempIntent.intentId, @"intentid shouldn't be nil");
    [tr makeTick:@{@"intent": tempIntent.intentId}];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(tickCreated, @"tick not created!");
    [req1 logoutDevice];
    [req1 loginUser:userB.username withPassword:userB.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    LikeRequest *lr = [[LikeRequest alloc] initWithContext:self.managedObjectContext];
    lr.delegate = self;
    [lr like:tempChallengeDay];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(likeSuccess, @"like didn't work!");
    likeSuccess = NO;
    [req1 logoutDevice];
    [req1 loginUser:userC.username withPassword:userC.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [lr like:tempChallengeDay];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(likeSuccess, @"like didn't work!");
    likeSuccess = NO;
    
    CommentRequest *cr1 = [[CommentRequest alloc] initWithContext:self.managedObjectContext];
    cr1.delegate = self;
    [cr1 createComment:tempChallengeDay comment:userC.uuidString];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(commentSuccess, @"comment not successfully created");
    commentSuccess = NO;
    [req1 logoutDevice];
    [req1 loginUser:userB.username withPassword:userB.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [cr1 createComment:tempChallengeDay comment:userB.uuidString];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(commentSuccess, @"comment not successfully created");
    commentSuccess = NO;
    
    [cr1 deleteComment:tempComment.commentId];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(commentDeleted, @"comment not successfully deleted");
    commentDeleted = NO;
    
    [req1 logoutDevice];
    [req1 loginUser:userA.username withPassword:userA.password];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    [cr1 createComment:tempChallengeDay comment:userA.uuidString];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(commentSuccess, @"comment not successfully created");
    
    
    ProfileRequest *pr = [[ProfileRequest alloc] initWithContext:self.managedObjectContext];
    pr.delegate = self;
    [pr getMyProfile];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
    STAssertTrue(profileReturned, @"profile didn't return!");
}

-(void) testDateParsing
{
    NSString* dateString = @"2013-08-31 20:28:59 +0000";
    NSDate *interpretedDate = [NSDate fromString:dateString];
    NIDINFO(@"date thinks it's here %@",interpretedDate);
    STAssertNotNil(interpretedDate, @"date shouldn't be nil");
    
}


@end
