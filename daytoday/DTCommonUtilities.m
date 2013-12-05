//
//  DTCommonUtilities.m
//  daytoday
//
//  Created by pasmo on 11/26/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonUtilities.h"

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

+ (NSCalendar *)commonCalendar
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedCalendar = nil;
  dispatch_once(&pred, ^{
    _sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
  });
  return _sharedCalendar;
}

//+ (NSCalendar *)calendar
//{
//  return [NSCalendar autoupdatingCurrentCalendar];
//}

@end
