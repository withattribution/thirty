//
//  DTChallengeCalendarHelpers.m
//  daytoday
//
//  Created by peanut on 7/13/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "DTChallengeCalendarSpecHelpers.h"
#import "MockPFObject.h"

@interface DTChallengeCalendarSpecHelpers (Private)

+ (PFObject *)challengeWithDuration:(NSNumber *)duration andFrequency:(NSNumber *)frequency;
+ (void)generateChallengeDaysToSimulateIntent:(PFObject *)intent;
+ (PFObject *)generateIntentStarting:(NSDate *)starting ending:(NSDate *)ending andIsAccomplished:(BOOL)finished;

@end

NSString *const kMockIntentUserId  = @"TompxG1KuJ";
NSString *const kMockChallengeId   = @"FwklKM8984";

@implementation DTChallengeCalendarSpecHelpers

+ (PFObject *)intentStartingToday
{
  return [self generateIntentStarting:[NSDate date]
                               ending:[[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                               value:29
                                                                              toDate:[NSDate date]
                                                                             options:0]
                    andIsAccomplished:NO];
}

+ (PFObject *)intentStartingOneWeekAgo
{
  return [self generateIntentStarting:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:-7
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
          
                               ending:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                               value:22
                                                                              toDate:[NSDate date]
                                                                             options:0]
                    andIsAccomplished:NO];
}

+ (PFObject *)intentHalfWayDone
{
  return [self generateIntentStarting:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:-15
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
          
                               ending:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:14
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
                    andIsAccomplished:NO];
}

+ (PFObject *)intentEndingInOneWeek
{
  return [self generateIntentStarting:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:-23
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
          
                               ending:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:6
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
                    andIsAccomplished:NO];
}

+ (PFObject *)intentEndingToday
{
  return [self generateIntentStarting:[[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                     value:-29
                                                                                    toDate:[NSDate date]
                                                                                   options:0]
                               ending:[NSDate date]
                    andIsAccomplished:NO];
}

+ (PFObject *)challengeWithDuration:(NSNumber *)duration andFrequency:(NSNumber *)frequency
{
//  PFObject *challenge = /*[NSMutableDictionary dictionary];*/[PFObject objectWithClassName:kDTChallengeClassKey];
  PFObject *challenge = [MockPFObject objectWithoutDataWithClassName:@"MockPFObject" objectId:kMockChallengeId];
  [challenge setObject:@"Fixture Description" forKey:kDTChallengeDescriptionKey];
  [challenge setObject:duration forKey:kDTChallengeDurationKey];
  [challenge setObject:frequency forKey:kDTChallengeFrequencyKey];
  [challenge setObject:@"Fixture Category" forKey:kDTChallengeCategoryKey];
  [challenge setObject:@"Fixture Challenge Name" forKey:kDTChallengeNameKey];

  [challenge setObject:[PFUser currentUser] forKey:kDTChallengeCreatedByKey];
  [challenge setObject:@(kDTChallengeVerificationTypeTick) forKey:kDTChallengeVerificationTypeKey];
  
  //mock challenge id for hashing process
//  [challenge setObjectId:kMockChallengeId];
//  NIDINFO(@"some id: %@",[challenge objectId]);

  return challenge;
}

+ (PFObject *)generateIntentStarting:(NSDate *)starting ending:(NSDate *)ending andIsAccomplished:(BOOL)finished
{
  PFObject *intent = [PFObject objectWithClassName:kDTIntentClassKey];

  [intent setObject:starting forKey:kDTIntentStartingKey];
  [intent setObject:ending forKey:kDTIntentEndingKey];
  [intent setObject:@(finished) forKey:kDTIntentAccomplishedIntentKey];

  //create a mock intent user object for hashing purposes
  PFObject *intentUser = [MockPFObject objectWithoutDataWithClassName:@"MockPFObject" objectId:kMockIntentUserId];
  [intent setObject:intentUser forKey:kDTIntentUserKey];

  [intent setObject:[self challengeWithDuration:[NSNumber numberWithInteger:30]
                                   andFrequency:[NSNumber numberWithInteger:1]]
             forKey:kDTIntentChallengeKey];

  //create the challenge days and cache, then return intent
  [self generateChallengeDaysToSimulateIntent:intent];

  return intent;
}

+ (void)generateChallengeDaysToSimulateIntent:(PFObject *)intent
{
  NSMutableArray *days = [NSMutableArray new];
  int i = 1;

  for (id start = [intent objectForKey:kDTIntentStartingKey];
       [[DTCommonUtilities commonCalendar] compareDate:start
                                                toDate:[intent objectForKey:kDTIntentEndingKey]
                                     toUnitGranularity:NSCalendarUnitDay] != NSOrderedDescending;
        start = [[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                       value:1
                                                      toDate:start
                                                     options:0])
  {
    PFObject *day = [PFObject objectWithClassName:kDTChallengeDayClassKey];
    [day setObject:[[intent objectForKey:kDTIntentChallengeKey]
                            objectForKey:kDTChallengeFrequencyKey]
            forKey:kDTChallengeDayTaskRequiredCountKey];

    [day setObject:[NSNumber numberWithInteger:0] forKey:kDTChallengeDayTaskCompletedCountKey];
    [day setObject:@(NO) forKey:kDTChallengeDayAccomplishedKey];
    [day setObject:[NSNumber numberWithInteger:i] forKey:kDTChallengeDayOrdinalDayKey];
//    NIDINFO(@"the day ordinal : %d",i);
//    NIDINFO(@"date generated: %@", start);
    [day setObject:@([DTCommonUtilities dayHashFromDate:start intent:intent]) forKey:kDTChallengeDayActiveHashKey];
//    NIDINFO(@"regular: %@ uint: %u",@([DTCommonUtilities dayHashFromDate:dateForHash intent:intent]),[DTCommonUtilities dayHashFromDate:dateForHash intent:intent]);
//    day.set("active",murmurHash3.x86.hash32(d.format("MM/DD/YYYY"),defaults.challengeUserSeed));
    [days addObject:day];
    i++;
  }
//  NIDINFO(@"NUMBER OF DAYS: %lu",(unsigned long)[days count]);
  [[DTCache sharedCache] cacheChallengeDays:days forIntent:intent];
}

+ (NSDate *)startingDate:(PFObject *)intent
{
  return [intent objectForKey:kDTIntentStartingKey];
}

+ (NSDate *)oneWeekAfterStarting:(PFObject *)intent
{
  return  [[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                         value:7
                                                        toDate:[intent objectForKey:kDTIntentStartingKey]
                                                       options:0];
}

+ (NSDate *)halfWayDone:(PFObject *)intent
{
  return  [[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                         value:15
                                                        toDate:[intent objectForKey:kDTIntentStartingKey]
                                                       options:0];
}

+ (NSDate *)lastWeekUntilEnding:(PFObject *)intent
{
  return  [[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                         value:-7
                                                        toDate:[intent objectForKey:kDTIntentEndingKey]
                                                       options:0];
}

+ (NSDate *)endingDate:(PFObject *)intent
{
  return [intent objectForKey:kDTIntentEndingKey];
}
@end
