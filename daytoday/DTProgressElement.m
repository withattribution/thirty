//
//  DTProgressElement.m
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTProgressElement.h"
#import "DTDotElement.h"
#import "NSCalendar+equalWithGranularity.h"

@implementation DTProgressColorGroup
@synthesize strokeColor,fillColor;

+(DTProgressColorGroup *) summaryProgressBackground
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor redColor];
    pcg.fillColor   = [UIColor whiteColor];
    return pcg;
}

+(DTProgressColorGroup *) summaryProgressForeground
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor redColor];
    pcg.fillColor   = [UIColor redColor];
    return pcg;
}

+(DTProgressColorGroup *) snapshotProgress
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor blueColor];
    pcg.fillColor   = [UIColor blueColor];
    return pcg;
}

@end

@implementation DTProgressRow
@synthesize style,phase,weekRow;

+ (DTProgressRow *)withEndStyle:(DTProgressRowEndStyle)end
                          phase:(DTProgressRowTemporalStatus)status
                            row:(NSArray *)row
{
    DTProgressRow *pr = [[DTProgressRow alloc] init];
    pr.style = end;
    pr.phase = status;
    pr.weekRow = row;
    return pr;
}
@end


@interface DTProgressElementLayout (){
    NSCalendar *layoutCalendar;
}

- (NSArray *)buildDTProgressRows;
- (NSArray *)buildChallengeCalendar:(NSInteger)forDuration;
- (NSArray *)dotForChallengeCalendar:(NSArray *)challengeDays;
- (NSArray *)weekRowsFrom:(NSArray *)dtDotCalendarArray;
- (NSArray *)progressRowsFromWeekRows:(NSArray *)weekRows;

- (DTProgressRowTemporalStatus)temporalStatusForRow:(NSArray *)row;
- (DTProgressRowEndStyle)endStyleForRow:(NSArray *)row;

- (NSSet *)setFromRow:(NSArray *)row;

- (DTProgressElement *)progressElementForDTProgressRow:(DTProgressRow *)progressRow;
- (CGFloat)progressUnitsForDTProgressRow:(DTProgressRow *)progressRow;

@end

@implementation DTProgressElementLayout
@synthesize intent,progressRows;

static int NUM_DAYS_FOR_ROW = 7;
static CGFloat EDGE_PADDING = 3.f;

- (id)initWithIntent:(Intent *)i
{
    self = [super init];
    if (self) {
        self.intent = i;
        layoutCalendar = [NSCalendar autoupdatingCurrentCalendar];
        self.progressRows = [self buildDTProgressRows];
    }
    return self;
}

#pragma mark Build Challenge Calendar with DTDotElements

- (NSArray *)buildDTProgressRows
{
    //build challenge calendar for challenge duration
    NSArray *challengeCalendarDays = [NSArray arrayWithArray:[self buildChallengeCalendar:[[self.intent.challenge duration] integerValue]]];
    
    //create a DTDotElement for each day of the challenge calender
    NSArray *dtDotsForChallengeCalendar = [NSArray arrayWithArray:[self dotForChallengeCalendar:challengeCalendarDays]];
    
    //separate calendar into weeks as an array of arrays
    NSArray *weekRows = [NSArray arrayWithArray:[self weekRowsFrom:dtDotsForChallengeCalendar]];
    
    //build DTProgressRow objects for
    return [self progressRowsFromWeekRows:weekRows];
}

- (NSArray *)buildChallengeCalendar:(NSInteger)forDuration
{
    NSArray *challengeDays = [[self.intent days] allObjects];
    
    ///////// BUILD A LIST OF CHALLENGE DAY FOR CHALLENGE DURATION //////////////
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSMutableArray *datesForDuration = [NSMutableArray arrayWithObject:self.intent.starting];
    
    for (int i = 1; i <= forDuration; i++) {
        [offset setDay:i];
        NSDate *nextDay = [layoutCalendar dateByAddingComponents:offset toDate:self.intent.starting options:0];
        [datesForDuration addObject:nextDay];
    }
    
    NSArray *safeArray = [NSArray arrayWithArray:datesForDuration];
    
    NSMutableArray *objectsToReplace = [[NSMutableArray alloc] init];
    NSMutableIndexSet *indexesToReplace = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i < [safeArray count]; i++ ) {
        for (int j = 0; j < [challengeDays count]; j++) {
            
            NSDate *challengeDayDate = (NSDate*)((ChallengeDay*)[challengeDays objectAtIndex:j]).day;
            NSDate *durationDate = (NSDate*)[safeArray objectAtIndex:i];
            ChallengeDay *chalDay = (ChallengeDay*)[challengeDays objectAtIndex:j];
            
            if ([layoutCalendar ojf_isDate:durationDate
                               equalToDate:challengeDayDate
                           withGranularity:NSDayCalendarUnit]) {
                [objectsToReplace addObject:chalDay];
                [indexesToReplace addIndex:i];
            }
        }
    }
    [datesForDuration replaceObjectsAtIndexes:indexesToReplace withObjects:objectsToReplace];
    //    for (int i = 0; i < [datesForDuration count]; i++) {
    //        if ([[datesForDuration objectAtIndex:i] class] == [ChallengeDay class]) {
    //            NSLog(@"i: %d and Challenge day with date: %@",i,[(ChallengeDay*)[datesForDuration objectAtIndex:i] day]);
    //        }else {
    //            NSLog(@"i: %d and date: %@",i,[datesForDuration objectAtIndex:i]);
    //        }
    //    }
    return datesForDuration;
}

- (NSArray *)dotForChallengeCalendar:(NSArray *)challengeDays
{
    NSArray *masterArray = [NSArray arrayWithArray:challengeDays];
    NSMutableArray *dotsForChallenge = [[NSMutableArray alloc] init];
    
    NSDate *today = [NSDate date];
    
    for (int i = 0; i < [masterArray count]; i++) {
        
        //check to see if object is a challenge day or a nsdate object
        if ([[masterArray objectAtIndex:i] class] == [ChallengeDay class]) {
            //                NSLog(@"i: %d and Challenge day with date: %@",i,[(ChallengeDay*)[allTheDates objectAtIndex:i] day]);
            
            //If there is a ChallengeDay for TODAY then the possible states are:
            //challenge day completed
            //participated but did not complete (partial completion view opportunity)
            //and active day dot but no completion
            if ([layoutCalendar ojf_isDate:[(ChallengeDay*)[masterArray objectAtIndex:i] day]
                               equalToDate:today
                           withGranularity:NSDayCalendarUnit]) {
                if ([((ChallengeDay*)[masterArray objectAtIndex:i]).completed boolValue]) {
                    //Make a dot for participated and did complete
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    //                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    //                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
                else {
                    //Make a dot for the state of "Participated but didn't complete"
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup someParticipationAndStillActiveColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    //                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    //                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
            }
            //If there is a challenge day for the past then the possible states are:
            //failed
            //participated but did not complete (failed but with some effort)
            //just didn't participate at all -- complete and utter failure
            if ([layoutCalendar ojf_compareDate:[(ChallengeDay*)[masterArray objectAtIndex:i] day]
                                         toDate:today
                              toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending) {
                //                NIDINFO(@"these are in the past: %@ today: %@",[sortedDurationDates objectAtIndex:i],today);
                if ([((ChallengeDay*)[masterArray objectAtIndex:i]).completed boolValue]) {
                    //Make a dot for participated and did complete
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    //                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    //                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
                else {
                    //Make a dot for the state of "Participated but didn't complete"
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup someParticipationButFailedColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    //                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    //                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
            }
        }
        //otherwise these are just regular NSDate objects
        else {
            //check if day is the day today
            if ([layoutCalendar ojf_isDate:([masterArray objectAtIndex:i])
                               equalToDate:today
                           withGranularity:NSDayCalendarUnit]) {
                //Make a dot for the active state of the day today and there is no participation for the day today
                DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                          andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
                                                                andDate:[masterArray objectAtIndex:i]];
                //                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                //                NSLog(@"****************************************************");
                [dotsForChallenge addObject:dot];
            }
            //check dates in the past
            if ([layoutCalendar ojf_compareDate:[masterArray objectAtIndex:i]
                                         toDate:today
                              toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending) {
                //Make a dot for failure state because you can't just up and change the past
                DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                          andColorGroup:[DTDotColorGroup failedDayColorGroup]
                                                                andDate:[masterArray objectAtIndex:i]];
                //                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                //                NSLog(@"****************************************************");
                [dotsForChallenge addObject:dot];
            }
            //check and handle all future dates
            if ([layoutCalendar ojf_compareDate:[masterArray objectAtIndex:i]
                                         toDate:today
                              toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
                //                NIDINFO(@"these are in the future: %@ today: %@",[sortedDurationDates objectAtIndex:i],today);
                //The future is simple because it's just chock full of opportunity
                //make a dot for the state of "USER HAS NOT PARTICIPATED"
                DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                          andColorGroup:[DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup]
                                                                andDate:[masterArray objectAtIndex:i]];
                //                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                //                NSLog(@"****************************************************");
                [dotsForChallenge addObject:dot];
            }
        }
    }
    return dotsForChallenge;
}

- (NSArray *)weekRowsFrom:(NSArray *)dtDotCalendarArray
{
    //break apart dtDotCalendar array into subarrays of 7 day long week-rows
    NSArray *swapArray = [NSArray arrayWithArray:dtDotCalendarArray];
    NSMutableArray *arrayOfArrays = [NSMutableArray array];
    
    int itemsRemaining = [swapArray count];
    int aa = 0;
    
    while(aa < [swapArray count]) {
        NSRange range = NSMakeRange(aa, MIN(NUM_DAYS_FOR_ROW, itemsRemaining));
        NSArray *subarray = [swapArray subarrayWithRange:range];
        [arrayOfArrays addObject:subarray];
        itemsRemaining-=range.length;
        aa+=range.length;
    }
    //    for (int qq = 0; qq < [arrayOfArrays count]; qq++) {
    //        for (int q1 = 0; q1 < [[arrayOfArrays objectAtIndex:qq] count]; q1++) {
    //            NSLog(@"%@", [[[arrayOfArrays objectAtIndex:qq] objectAtIndex:q1] dotDate]);
    //        }
    //    }
    NSMutableArray *tempWeekRows = [NSMutableArray arrayWithArray:arrayOfArrays];
    ////////// PAD WEEK ROWS WITH EXTRA DAYS UNTIL ROW IS FULL //////////
    for (int i = 0; i < [tempWeekRows count]; i++) {
        if ([[tempWeekRows objectAtIndex:i] count] < 7) {
            //                NIDINFO(@"this is the weekrow that needs to be padded: %@", [weekRows objectAtIndex:i]);
            //this week-row needs to be padded and replaced
            int indexToReplace = i;
            
            //grab dot number from previous dot and extend into the future to pad the week-row
            NSMutableArray *paddedWeekRow = [NSMutableArray arrayWithArray:[tempWeekRows objectAtIndex:i]];
            DTDotElement *lastDot = [paddedWeekRow lastObject];
            
            NSDateComponents *paddedOffSetComponent = [layoutCalendar components:NSCalendarUnitDay fromDate:lastDot.dotDate];
            
            for (int j = 1; [paddedWeekRow count] < 7; j++) {
                [paddedOffSetComponent setDay:j];
                NSDate *paddedDate = [layoutCalendar dateByAddingComponents:paddedOffSetComponent toDate:lastDot.dotDate options:0];
                DTDotElement *paddedFutureDot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                      andColorGroup:[DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup]
                                                                            andDate:paddedDate];
                [paddedWeekRow addObject:paddedFutureDot];
            }
            [tempWeekRows replaceObjectAtIndex:indexToReplace withObject:paddedWeekRow];
        }
    }
    return tempWeekRows;
}

- (NSArray *)progressRowsFromWeekRows:(NSArray *)weekRows
{
    NSMutableArray *prows = [[NSMutableArray alloc] initWithCapacity:[weekRows count]];
    
    for(int i = 0; i < [weekRows count]; i++){
        DTProgressRowTemporalStatus status = [self temporalStatusForRow:[weekRows objectAtIndex:i]];
        DTProgressRowEndStyle style = [self endStyleForRow:[weekRows objectAtIndex:i]];
        [prows addObject:[DTProgressRow withEndStyle:style phase:status row:[weekRows objectAtIndex:i]]];
    }
    
    return prows;
}

- (DTProgressRowTemporalStatus)temporalStatusForRow:(NSArray *)row
{
    NSDate *today = [NSDate date];

    //test if all indexes in weekrow evaluate to a past date
    NSIndexSet *past = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([layoutCalendar ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending);
    }];
    
    if ([past count] == [row count]) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowPast;
    }
    
    //test if any indexes in weekrow evaluate to a today's date
    NSIndexSet *current = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([layoutCalendar ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
    }];
    
    if ([current count] == 1) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowCurrent;
    }
    
    //test if all indexes in weekrow evaluate to a future date
    NSIndexSet *future = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
        return ([layoutCalendar ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending);
    }];
    
    if ([future count] == [row count]) {
        //one index contains the current date so entire row is the current row
        return DTProgressRowFuture;
    }

    return DTProgressRowTemporalStatusUndefined;
}

- (DTProgressRowEndStyle)endStyleForRow:(NSArray *)row
{
    NSSet *rowSet = [self setFromRow:row];
    
    if ([self temporalStatusForRow:row] == DTProgressRowPast &&
        (![rowSet containsObject:self.intent.starting] && ![rowSet containsObject:self.intent.ending]) )
        return DTProgressRowEndFlat;
    if ([self temporalStatusForRow:row] == DTProgressRowCurrent && ![rowSet containsObject:self.intent.starting])
        return DTProgressRowEndFlatLeft;
    if ([self temporalStatusForRow:row] == DTProgressRowPast && [rowSet containsObject:self.intent.starting])
        return DTProgressRowEndFlatRight;
    if ([self temporalStatusForRow:row] == DTProgressRowCurrent && [rowSet containsObject:self.intent.starting])
        return DTProgressRowEndBothRounded;
    return DTProgressRowEndUndefined;
}

- (NSSet *)setFromRow:(NSArray *)row
{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = 0; i < [row count]; i++) {
        [dates addObject:[(DTDotElement*)[row objectAtIndex:i] dotDate]];
    }
    return [NSSet setWithArray:dates];
}

#pragma mark Build Progress Element Views From DTProgressRow Objects

- (NSArray *)progressSnapShotElements
{
    NSMutableArray *progressElements = [[NSMutableArray alloc] initWithCapacity:2]; //make a 2 row snapshot view
    
    for (int i = 0; i < [self.progressRows count]; i++) {
        if ([(DTProgressRow*)[self.progressRows objectAtIndex:i] phase] == DTProgressRowCurrent) {
            if (i == 0) {
                //add the current progress row first then take the second progressrow and break
                [progressElements addObject:[self progressElementForDTProgressRow:[self.progressRows objectAtIndex:i]]];
                [progressElements addObject:[self progressElementForDTProgressRow:[self.progressRows objectAtIndex:(i+1)]]];
                break;
            }else {
                //add previous progress row and current progress row build progress elememts add to array and break
                [progressElements addObject:[self progressElementForDTProgressRow:[self.progressRows objectAtIndex:(i-1)]]];
                [progressElements addObject:[self progressElementForDTProgressRow:[self.progressRows objectAtIndex:(i)]]];
                break;
            }
        }
    }
    return progressElements;
}

- (DTProgressElement *)progressElementForDTProgressRow:(DTProgressRow *)progressRow
{
    CGRect GENERIC_DOT_FRAME = CGRectMake(0.f, 0.f, 40.f, 40.f);

    DTProgressElement *rowElement = [[DTProgressElement alloc] initWithEndStyle:progressRow.style
                                                                  andColorGroup:[DTProgressColorGroup snapshotProgress]
                                                                  progressUnits:[self progressUnitsForDTProgressRow:progressRow]];
    for (int i = 0; i < [progressRow.weekRow count]; i++) {
        CGRect DTDotElementFrame = CGRectMake(i*GENERIC_DOT_FRAME.size.width+EDGE_PADDING,
                                              0.f,
                                              rowElement.frame.size.height,
                                              rowElement.frame.size.height);
        DTDotElement *dot = [progressRow.weekRow objectAtIndex:i];
        [dot setFrame:DTDotElementFrame];
        [rowElement addSubview:dot];
    }
    return rowElement;
}

- (CGFloat)progressUnitsForDTProgressRow:(DTProgressRow *)progressRow
{
    NSDate *today = [NSDate date];

    if (progressRow.phase == DTProgressRowCurrent) {
        NSIndexSet *currentDayIndex = [progressRow.weekRow indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
            return ([layoutCalendar ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
        }];
        return ([currentDayIndex firstIndex]+1)*40.f; //Generic DTDotElement frame width = 40.f
    }else {
        return 320.f; //full width -- doesn't really matter though since this is only used if the endstyle is not flat aka DTProgressRowCurrent
    }
}

//- (id)initWithFrame:(CGRect)frame forDayInRow:(int)day
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        DTDotElementFrameWidth = [self getFrameWidth];
//        progress = DTDotElementFrameWidth * day;
//        
//        pElement = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.0f,
//                                                                       0.0f,
//                                                                       self.frame.size.width,
//                                                                       self.frame.size.height)
//                                              andColorGroup:[DTProgressColorGroup snapshotProgress]
//                                              progressUnits:progress];
//        //        if(row is for previous week) {
//        //            if(row contains start-day){
//        [pElement drawFlatRightProgressElement];
//        //           else {
//        //            [pElement drawFlatProgressElement];
//        //            }
//        //        }else{
//        //            if(row contains start-day){
//        //            [pElement drawRoundedProgressElement];
//        //            else {
//        //            [pElement drawFlatLeftProgressElement];
//        //            }
//        //        }
//        [self addSubview:pElement];
//        [self drawDTDotElementsForDays:NUM_DAYS_FOR_ROW];
//    }
//    return self;
//}

//- (id)initWithFrame:(CGRect)frame forSummaryWithPercent:(CGFloat)percentComplete
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        progress = percentComplete;
//        [self dayProgressSummary];
//    }
//    return self;
//}

//- (CGFloat)getFrameWidth
//{
//    return (self.frame.size.width - (2*EDGE_PADDING)) / NUM_DAYS_FOR_ROW;
//}

////#TODO NEED TO LABEL WITH ACTUAL DAY NUMBER
//- (void)drawDTDotElementsForDays:(int)days
//{
//    for (int i = 0; i < NUM_DAYS_FOR_ROW; i++) {
//        CGRect DTDotElementFrame = CGRectMake(i*DTDotElementFrameWidth+EDGE_PADDING,
//                                              0.,
//                                              pElement.frame.size.height,
//                                              pElement.frame.size.height);
//        
//        DTDotElement *element = [[DTDotElement alloc] initWithFrame:DTDotElementFrame
//                                                      andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
//                                                          andNumber:[NSNumber numberWithInt:i]];
//        [self addSubview:element];
//    }
//}

// the progress element for the summary
// two days centered vertically and at each endpoint spaced from left and right edges of the screen
// both ends rounded and spaced with equal margins
// unlayer with clear or white fill and colored stroke to imitate progress view
//- (void)dayProgressSummary
//{
//    DTProgressElement *summaryProgressBackground = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.f,
//                                                                                                       0.f,
//                                                                                                       self.frame.size.width,
//                                                                                                       self.frame.size.height)
//                                                                              andColorGroup:[DTProgressColorGroup summaryProgressBackground]
//                                                                                withPercent:1.f];
//    [self addSubview:summaryProgressBackground];
//    
//    DTProgressElement *summaryProgressForeground = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.f,
//                                                                                                       0.f,
//                                                                                                       self.frame.size.width ,
//                                                                                                       self.frame.size.height)
//                                                                              andColorGroup:[DTProgressColorGroup summaryProgressForeground]
//                                                                                withPercent:progress];
//    [summaryProgressBackground leftCenter];
//    [self addSubview:summaryProgressForeground];
//    
//    DTDotElement *startDay = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f,
//                                                                            0.f,
//                                                                            summaryProgressForeground.frame.size.height,
//                                                                            summaryProgressForeground.frame.size.height)
//                                                   andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
//                                                       andNumber:[NSNumber numberWithInt:11]];
//    [startDay setCenter:[summaryProgressForeground leftCenter]];
//    [summaryProgressForeground addSubview:startDay];
//    
//    DTDotElement *endDay = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f,
//                                                                          0.f,
//                                                                          self.frame.size.height,
//                                                                          self.frame.size.height)
//                                                 andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
//                                                     andNumber:[NSNumber numberWithInt:28]];
//    
//    [endDay setCenter:[summaryProgressForeground rightCenter]];
//    [self addSubview:endDay];
//}
@end

@interface DTProgressElement () {
    CGFloat endRadius;
    CGFloat progressUnits; //length of progressElement coverage in discreet DTDotElement units
    DTProgressColorGroup *progressColorGroup;
}

- (void)drawForStyle:(DTProgressRowEndStyle)style;
- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)radius angleInDegrees:(double)angleInDegrees;

@end

@implementation DTProgressElement
@synthesize percent,leftCenter,rightCenter,radius;

static CGFloat END_PADDING = 3.f;
static CGFloat DOT_STROKE_WIDTH = 1.5f;


- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units
{
    CGRect GENERIC_PROGRESS_FRAME = CGRectMake(0.f, 0.f, 320.f, 40.f);

    self = [super initWithFrame:GENERIC_PROGRESS_FRAME];
    if (self) {
        progressColorGroup = pcg;
        progressUnits = units;
        [self determineRoundedRadius];
        [self drawForStyle:style];
    }
    return self;
}

- (id)initForSummaryElementWithColorGroup:(DTProgressColorGroup *)pcg percent:(CGFloat)p
{
    CGRect GENERIC_PROGRESS_FRAME = CGRectMake(0.f, 0.f, 320.f, 40.f);
    self = [super initWithFrame:GENERIC_PROGRESS_FRAME];
    if (self) {
        self.percent = p;
        progressColorGroup = pcg;
        [self determineRoundedRadius];
        progressUnits = [self convertPercentToProgressUnits:p];
        [self drawRoundedProgressElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p
{
    self = [super initWithFrame:frame];
    if (self) {
        self.percent = p;
        progressColorGroup = pcg;
        [self determineRoundedRadius];
        progressUnits = [self convertPercentToProgressUnits:p];
        [self drawRoundedProgressElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units
{
    self = [super initWithFrame:frame];
    if (self) {
        progressColorGroup = pcg;
        progressUnits = units;
        [self determineRoundedRadius];
    }
    return self;
}

- (void)drawForStyle:(DTProgressRowEndStyle)style
{
    switch (style) {
        case 0:
            [self drawFlatProgressElement];
            break;
        case 1:
            [self drawFlatLeftProgressElement];
            break;
        case 2:
            [self drawFlatRightProgressElement];
            break;
        case 3:
            [self drawRoundedProgressElement];
            break;
        default:
            //DTProgressRowEndUndefined draws nothing but DTProgressElement does return a valid frame
            break;
    }
}

- (void)drawFlatProgressElement
{
    CGPoint startPoint = CGPointMake(self.frame.origin.x - END_PADDING,self.frame.size.height);

    UIBezierPath *progressPath = [UIBezierPath bezierPath];

    [progressPath moveToPoint:startPoint];
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING, 0.0f)];
    [progressPath addLineToPoint:CGPointMake(self.frame.size.width+END_PADDING,progressPath.currentPoint.y)];
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x, self.frame.size.height)];
    [progressPath addLineToPoint:startPoint];

    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFlatLeftProgressElement
{
    CGPoint startPoint = CGPointMake(self.frame.origin.x-END_PADDING,0.0f);
    CGPoint endCenter = CGPointZero;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    
    [progressPath moveToPoint:startPoint];
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING,0.0f)];
    [progressPath addLineToPoint:CGPointMake(progressUnits, progressPath.currentPoint.y)];
    int sampleCount = 40;
    CGFloat angleInDegrees = 270;
    CGFloat delta = 180.0f/sampleCount;
    angleInDegrees = 270;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:CGPointMake(progressUnits+point.x, point.y)];
    }
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING, progressPath.currentPoint.y)];
    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFlatRightProgressElement
{
    //Flat right is a special variant of the progress element that will only be drawn when the first day
    //exists in the current row, and the row-week is completed.
    progressUnits = (self.frame.size.width - END_PADDING);
    //length of the progress units always extends to the full right edge of the screen since the active day
    //is not in the current week-row.
    
    CGPoint endCenter = CGPointZero;
    CGPoint startPoint = [self pointOnCircleWithCenter:endCenter
                                                radius:endRadius
                                        angleInDegrees:90];

    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:startPoint];
    
    int sampleCount = 40;
    CGFloat delta = 180.0f/sampleCount;
    CGFloat angleInDegrees = 90;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:point];
    }
    [progressPath addLineToPoint:CGPointMake(progressUnits, progressPath.currentPoint.y)];
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x, self.frame.size.height)];
    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawRoundedProgressElement
{
    CGPoint endCenter = CGPointZero;
    CGPoint startPoint = [self pointOnCircleWithCenter:endCenter
                                                radius:endRadius
                                        angleInDegrees:90];

    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:startPoint];
    
    int sampleCount = 40;
    CGFloat delta = 180.0f/sampleCount;
    CGFloat angleInDegrees = 90;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:CGPointZero
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:point];
    }
    
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x+progressUnits, progressPath.currentPoint.y)];

    angleInDegrees = 270;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:CGPointMake(progressUnits+point.x, point.y)];
    }

    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFinalShapeWithPath:(UIBezierPath *)path
{
    CAShapeLayer *progressShape  = [CAShapeLayer layer];
    progressShape.opacity        = 1.0;
    progressShape.position       = CGPointMake(END_PADDING,0.f);
    progressShape.fillColor      = progressColorGroup.fillColor.CGColor;
    progressShape.strokeColor    = progressColorGroup.strokeColor.CGColor;
    progressShape.lineWidth      = DOT_STROKE_WIDTH;
    progressShape.lineCap        = kCALineCapRound;
    progressShape.lineJoin       = kCALineJoinRound;
    progressShape.path           = path.CGPath;
    
    [self.layer addSublayer:progressShape];
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees
{
    float x = (float)(r * cos(angleInDegrees * M_PI / 180)) + r;
    float y = (float)(r * sin(angleInDegrees * M_PI / 180)) + r;
    return CGPointMake(x, y);
}

-(CGFloat) convertPercentToProgressUnits:(CGFloat)p
{
    return (self.frame.size.width - (2*END_PADDING) - (2*endRadius))*p;
}

-(void) determineRoundedRadius
{
    endRadius = (self.frame.size.height)/2.f;
}

- (CGPoint)rightCenter
{
    return CGPointMake(endRadius+progressUnits+END_PADDING, self.frame.size.height/2.f);
}

- (CGPoint)leftCenter
{
    return CGPointMake(endRadius+END_PADDING, self.frame.size.height/2.f);
}

@end
