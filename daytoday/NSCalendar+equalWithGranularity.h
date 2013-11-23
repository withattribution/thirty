//
//  NSCalendar+equalWithGranularity.h
//  daytoday
//
//  Created by pasmo on 10/13/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (equalWithGranularity)

- (BOOL)ojf_isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 withGranularity:(NSCalendarUnit)granularity;

- (BOOL)ojf_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;

- (NSComparisonResult)ojf_compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

@end
