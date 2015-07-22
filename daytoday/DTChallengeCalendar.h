//
//  DTChallengeCalendar.h
//  daytoday
//
//  Created by pasmo on 12/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTProgressRow.h"
#import "DTProgressElement.h"
#import <Foundation/Foundation.h>

@interface DTChallengeCalendar : NSObject  <DTProgressRowDataSource>

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

+ (DTChallengeCalendar *)calendarWithIntent:(PFObject *)intent;

- (void)setProgressRowLength:(NSUInteger)length;
- (NSUInteger)rowLength;

- (NSArray *)challengeDates;
- (NSArray *)rows;

@end
