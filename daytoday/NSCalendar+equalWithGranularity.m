//
//  NSCalendar+equalWithGranularity.m
//  daytoday
//
//  Created by pasmo on 10/13/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

// removed from ios7 beta but added back because it's amazeballs
// https://github.com/ojfoggin/NSCalendar-EqualWithGranularity/blob/master/NSCalendar%2BequalWithGranularity.h

#import "NSCalendar+equalWithGranularity.h"

@implementation NSCalendar (equalWithGranularity)

- (BOOL)ojf_isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 withGranularity:(NSCalendarUnit)granularity
{
    if ([date1 isEqualToDate:date2]) {
        return YES;
    }
    
    int componentFlags = [self ojf_componentFlagsWithGranularity:granularity];
    
    date1 = [self ojf_dateFromDate:date1 withComponentFlags:componentFlags];
    date2 = [self ojf_dateFromDate:date2 withComponentFlags:componentFlags];
    
    return [date1 isEqualToDate:date2];
}

- (BOOL)ojf_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2
{
    int componentFlags = [self ojf_componentFlagsWithGranularity:NSCalendarUnitDay];
    
    date1 = [self ojf_dateFromDate:date1 withComponentFlags:componentFlags];
    date2 = [self ojf_dateFromDate:date2 withComponentFlags:componentFlags];
 
    return [date1 isEqualToDate:date2];
}

- (NSComparisonResult)ojf_compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit
{
    int componentFlags = [self ojf_componentFlagsWithGranularity:NSCalendarUnitDay];
    
    date1 = [self ojf_dateFromDate:date1 withComponentFlags:componentFlags];
    date2 = [self ojf_dateFromDate:date2 withComponentFlags:componentFlags];
    
    return [date1 compare:date2];
}

- (int)ojf_componentFlagsWithGranularity:(NSCalendarUnit)granularity
{
    int componentFlags = 0;
    
    for (int i = 1<<1 ; i <= granularity ; i = i<<1) {
        componentFlags = componentFlags | i;
    }
    
    return componentFlags;
}

- (NSDate *)ojf_dateFromDate:(NSDate *)date withComponentFlags:(int)componentFlags
{
    NSDateComponents *components = [self components:componentFlags fromDate:date];
    
    return [self dateFromComponents:components];
}

@end
