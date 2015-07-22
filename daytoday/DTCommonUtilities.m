//
//  DTCommonUtilities.m
//  daytoday
//
//  Created by pasmo on 11/26/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonUtilities.h"
#import "MurmurHash.h"

@implementation DTCommonUtilities

+ (NSInteger)minutesFromGMTForDate:(NSDate *)date
{
  return ([[NSTimeZone localTimeZone] secondsFromGMTForDate:date]/60.f);
}

+ (NSDateFormatter *)displayDayFormatter
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedFormatter = nil;
  dispatch_once(&pred, ^{
    _sharedFormatter = [DTCommonUtilities dayformatter];
  });
  return _sharedFormatter;
}

+ (NSDateFormatter *)dayformatter
{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  if([PFUser currentUser]) {
    //convert back from minutes (stored user offset) to seconds
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[[PFUser currentUser] objectForKey:kDTUserGMTOffset] integerValue]*60]];
  }
  else{
    [df setTimeZone:[NSTimeZone localTimeZone]];
  }
  [df setDateFormat:kDTDateFormatNSDateDisplayDay];
  return df;
}

+ (NSDateFormatter *)dayformatterForSeed
{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  if([PFUser currentUser]) {
    //convert back from minutes (stored user offset) to seconds
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:[[[PFUser currentUser] objectForKey:kDTUserGMTOffset] integerValue]*60]];
  }
  else{
    [df setTimeZone:[NSTimeZone localTimeZone]];
  }
  [df setDateFormat:kDTDateFormatNSDateDisplayForSeed];
  return df;
}

+ (NSCalendar *)commonCalendar
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedCalendar = nil;
  dispatch_once(&pred, ^{
    _sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
  });
  return _sharedCalendar;
}

+ (uint32_t)challengeUserSeedFromIntent:(PFObject *)intent
{
  MurmurHash *hash = [[MurmurHash alloc] init];
  uint32_t userSeed = [hash hash32:[[intent objectForKey:kDTIntentUserKey] objectId]];
  return [hash hash32:[[intent objectForKey:kDTIntentChallengeKey] objectId]  withSeed:userSeed];
}

+ (uint32_t)dayHashFromDate:(NSDate *)date intent:(PFObject *)intent
{
  MurmurHash *hash = [[MurmurHash alloc] init];
  return [hash hash32:[[DTCommonUtilities dayformatterForSeed] stringFromDate:date]
             withSeed:[DTCommonUtilities challengeUserSeedFromIntent:intent]];
}

+ (BFTask *)isValidDateForActiveIntent:(PFObject *)activeIntent
{
  NSDate *today = [NSDate date];
  NSComparisonResult starting = [[self commonCalendar] compareDate:[activeIntent objectForKey:kDTIntentStartingKey]
                                                            toDate:today
                                                 toUnitGranularity:NSCalendarUnitDay];
  NSComparisonResult ending = [[self commonCalendar] compareDate:[activeIntent objectForKey:kDTIntentEndingKey]
                                                          toDate:today
                                               toUnitGranularity:NSCalendarUnitDay];
  return [BFTask taskWithResult:@((starting == NSOrderedSame ||
                                   starting == NSOrderedAscending) &&
                                    (ending == NSOrderedSame ||
                                     ending == NSOrderedDescending))];
}

+ (NSInteger)durationOfChallengeFromIntent:(PFObject *)intent
{

  NSUInteger startOrdinalDay = [[self commonCalendar] ordinalityOfUnit:NSDayCalendarUnit
                                                               inUnit:NSYearCalendarUnit
                                                              forDate:[intent objectForKey:kDTIntentStartingKey]];

  NSUInteger endOridinalDay = [[self commonCalendar] ordinalityOfUnit:NSDayCalendarUnit
                                                               inUnit:NSYearCalendarUnit
                                                              forDate:[intent objectForKey:kDTIntentEndingKey]];
  // +1 is to include the last entire day in the duration
  return (endOridinalDay - startOrdinalDay + 1);
}

@end


