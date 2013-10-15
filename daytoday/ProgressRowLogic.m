//
//  ProgressRowLogic.m
//  daytoday
//
//  Created by pasmo on 10/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressRowLogic.h"

#import "DTDotElement.h"
#import "DTProgressElement.h"



#import "NSCalendar+equalWithGranularity.h"

@interface ProgressRowLogic ()

- (NSSet *)rowDatesAsSet;

@end


@implementation ProgressRowLogic
@synthesize row,rowDateSet,rowIntent;

- (id)initWithRow:(NSArray*)weekRow withIntent:(Intent *)intent
{
    self = [super init];
        if (self) {
            self.rowIntent = intent;
            self.row = [NSArray arrayWithArray:weekRow];
            self.rowDateSet = [self rowDatesAsSet];
            
            NSLog(@"START DATE: %@ END DATE: %@",rowIntent.starting,rowIntent.ending);
        }
    return self;
}

- (NSSet *)rowDatesAsSet
{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    NSLog(@"**************************************");
    for (int i = 0; i < [self.row count]; i++) {
        NSLog(@"row: %d and date: %@",i,[(DTDotElement*)[self.row objectAtIndex:i] dotDate]);
        [dates addObject:[(DTDotElement*)[self.row objectAtIndex:i] dotDate]];
    }
    NSLog(@"**************************************");

    return [NSSet setWithArray:dates];
}

- (DTProgressRowEndStyle)endStyleForRow
{
    if ([self temporalStatusForRow] == DTProgressRowPast && (![self.rowDateSet containsObject:self.rowIntent.starting] && ![self.rowDateSet containsObject:self.rowIntent.ending]) ) {
        return DTProgressRowEndFlat;
    }
    
    if ([self temporalStatusForRow] == DTProgressRowCurrent && ![self.rowDateSet containsObject:self.rowIntent.starting]) {
        return DTProgressRowEndFlatLeft;
    }
    
    if ([self temporalStatusForRow] == DTProgressRowPast && [self.rowDateSet containsObject:self.rowIntent.starting]) {
        return DTProgressRowEndFlatRight;
    }
    
    if ([self temporalStatusForRow] == DTProgressRowCurrent && [self.rowDateSet containsObject:self.rowIntent.starting]) {
        return DTProgressRowEndBothRounded;
    }
    
    return DTProgressRowEndUndefined;
}


- (DTProgressRowTemporalStatus)temporalStatusForRow
{
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    
    //test if all indexes in weekrow evaluate to a past date
    NSIndexSet *past = [self.row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([cal ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending);
    }];
    
    if ([past count] == [self.row count]) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowPast;
    }
    
    //test if any indexes in weekrow evaluate to a today's date
    NSIndexSet *current = [self.row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([cal ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
    }];
    
    if ([current count] == 1) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowCurrent;
    }
    
    //test if all indexes in weekrow evaluate to a future date
    NSIndexSet *future = [self.row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([cal ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending);
    }];

    if ([future count] == [self.row count]) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowFuture;
    }
    
    return DTProgressRowTemporalStatusUndefined;
}



@end
