//
//  NSCalendar+equalWithGranularity.h
//  daytoday
//
//  Created by pasmo on 10/13/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (equalWithGranularity)

- (BOOL)ojf_isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 withGranularity:(NSCalendarUnit)granularity;

- (BOOL)ojf_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;
/*
 This API compares the given dates down to the given unit, reporting them equal if they are the same in the given unit and all larger units, otherwise either less than or greater than.
 */
- (NSComparisonResult)ojf_compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

@end
 