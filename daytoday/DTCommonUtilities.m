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

@end
