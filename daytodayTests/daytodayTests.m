//
//  daytodayTests.m
//  daytodayTests
//
//  Created by pasmo on 12/5/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "NIDebuggingTools.h"
#import <SenTestingKit/SenTestingKit.h>

@interface daytodayTests : SenTestCase

@end

@implementation daytodayTests

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  [[DTCache sharedCache] clear];
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testMath
{
  STAssertTrue(( (2+2) == 4),@"Math stopped working.");
}

- (void)testDateParsing
{
  NSDateFormatter *df = [DTCommonUtilities displayDayFormatter];
  NSString* displayString = [df stringFromDate:[NSDate date]];
  NIDINFO(@"display day for today: %@",displayString);
}

- (PFObject *)buildChallenge
{
  PFObject *challenge = [PFObject objectWithClassName:kDTChallengeClassKey];
  [challenge setObject:@"description" forKey:kDTChallengeDescriptionKey];
  [challenge setObject:@(30) forKey:kDTChallengeDurationKey];
  [challenge setObject:@(1) forKey:kDTChallengeFrequencyKey];
  [challenge setObject:@"category" forKey:kDTChallengeCategoryKey];
  [challenge setObject:@"name" forKey:kDTChallengeNameKey];
//  [challenge setObject:@"testCategory" forKey:kDTChallengeImageKey];
//  [challenge setObject:@"testCategory" forKey:kDTChallengeCreatedByKey];
  [challenge setObject:kDTChallengeVerificationTypeTick forKey:kDTChallengeVerificationTypeKey];
  [challenge setObjectId:@"iAEEL19vOK"];
  
  return challenge;
}

- (PFObject *)buildIntent
{
  PFObject *intent = [PFObject objectWithClassName:kDTIntentClassKey];
  [intent setObject:[NSDate date] forKey:kDTIntentStartingKey];
  [intent setObject:[NSDate dateWithTimeInterval:(60*60*24*30) sinceDate:[NSDate date]] forKey:kDTIntentEndingKey];
//  [intent setObject:@"testCategory" forKey:kDTIntentUserKey];
//  [intent setObject:@"testCategory" forKey:kDTIntentChallengeDays];
  [intent setObject:@(NO) forKey:kDTIntentAccomplishedIntentKey];
//  [intent setObject:@"testCategory" forKey:kDTIntentChallengeKey];
  [intent setObjectId:@"m88LIFjt9r"];
  
  return intent;
}

- (PFUser *)buildPFUser
{
  PFUser *user = [PFUser objectWithClassName:@"User"];
  [user setObject:@"username" forKey:@"username"];
  [user setObjectId:@"UcPhbzrS9A"];
  return user;
}

- (void)testIntentPFObject
{
  PFObject *intent = [self buildIntent];
  STAssertTrue([[intent objectForKey:kDTIntentStartingKey] isKindOfClass:[NSDate class]], @"Intent start date should be a date");
  STAssertTrue([[intent objectForKey:kDTIntentEndingKey] isKindOfClass:[NSDate class]], @"Intent end date should be a date");
  STAssertEquals([[intent objectForKey:kDTIntentAccomplishedIntentKey] boolValue], NO, @"Intent 'accomplished' key should be false");
  STAssertEquals([intent objectId], @"m88LIFjt9r" , @"Intent objectId key incorrect");
}

- (void)testChallengePFObject
{
  PFObject *challenge = [self buildChallenge];
  STAssertEquals([challenge objectForKey:kDTChallengeDescriptionKey], @"description" , @"Challenge description key incorrect");
  STAssertEquals([[challenge objectForKey:kDTChallengeDurationKey] intValue], 30 , @"Challenge duration int incorrect");
  STAssertEquals([[challenge objectForKey:kDTChallengeFrequencyKey] intValue], 1 , @"Challenge frequency int incorrect");
  STAssertEquals([challenge objectForKey:kDTChallengeCategoryKey], @"category" , @"Challenge category key incorrect");
  STAssertEquals([challenge objectForKey:kDTChallengeNameKey], @"name" , @"Challenge name key incorrect");
  STAssertEquals([challenge objectForKey:kDTChallengeVerificationTypeKey], kDTChallengeVerificationTypeTick , @"Challenge verification type key incorrect");
  STAssertEquals([challenge objectId], @"iAEEL19vOK" , @"Challenge objectId key incorrect");
}

- (void)testPFUser
{
  PFUser *user = [self buildPFUser];
  STAssertEquals([user objectForKey:@"username"], @"username" , @"PFUser username key incorrect");
  STAssertEquals([user objectId], @"UcPhbzrS9A" , @"PFUser objectId key incorrect");
}

- (void)testCacheActiveIntent
{
  PFObject *intent = [self buildIntent];
  PFUser *user     = [self buildPFUser];
  
  [[DTCache sharedCache] cacheActiveIntent:intent user:user];
  PFObject *cachedActiveIntent = [[DTCache sharedCache] activeIntentForUser:user];
//  NIDINFO(@"the IntentId: %@ and CachedIntentId: %@", [intent objectId], [cachedActiveIntent objectId]);
  STAssertEquals([intent objectId], [cachedActiveIntent objectId], @"Intent id should equal Cached Intent id");
}

- (void)testRetrieveChallengeWithCachedActiveIntent
{
  PFObject *intent    = [self buildIntent];
  PFUser *user        = [self buildPFUser];
  PFObject *challenge = [self buildChallenge];
  
  [[DTCache sharedCache] cacheActiveIntent:intent user:user];
  [[DTCache sharedCache] cacheChallenge:challenge forIntent:[[DTCache sharedCache] activeIntentForUser:user]];
  
  PFObject *cachedChallenge = [[DTCache sharedCache] challengeForIntent:[[DTCache sharedCache] activeIntentForUser:user]];
//  NIDINFO(@"the challengeId: %@ and CachedChallengeId: %@", [challenge objectId], [cachedChallenge objectId]);
  STAssertEquals([challenge objectId], [cachedChallenge objectId], @"Challenge id should equal Cached Challenge id");
}

//- (void)testExample
//{
//    STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}
















@end
