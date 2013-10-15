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

//@interface DTProgressElementLayout (){
//    DTProgressElement* pElement;
//    CGFloat DTDotElementFrameWidth;
//    CGFloat progress;
//}
//
//@end

@interface DTProgressElementLayout (){
    NSCalendar *layoutCalendar;
    NSArray *challengeCalendarDays;
    NSArray *dtDotsForChallengeCalendar;
    
    NSDate *startDate;
    NSDate *endDate;
}

- (NSArray*)buildChallengeCalendar:(NSInteger)forDuration;
- (NSSet *)rowDatesAsSet;

@end

@implementation DTProgressElementLayout
@synthesize row,rowDateSet,intent,layoutView;

static int NUM_DAYS_FOR_ROW = 7;
static CGFloat EDGE_PADDING = 3.f;


- (id)initWithRow:(NSArray*)weekRow withIntent:(Intent *)i
{
    self = [super init];
    if (self) {
        self.intent = i;
        self.row = [NSArray arrayWithArray:weekRow];
        self.rowDateSet = [self rowDatesAsSet];
//        UIView *test = [[UIView alloc] initWithFrame:CGRectZero];
//        self.layoutView = test;
    }
    
    return self;
}

- (id)initWithIntent:(Intent *)i
{
    self = [super init];
    if (self) {
        self.intent = i;
        layoutCalendar = [NSCalendar autoupdatingCurrentCalendar];
        
        
        challengeCalendarDays = [NSArray arrayWithArray:[self buildChallengeCalendar:[[self.intent.challenge duration] integerValue]]];
        dtDotsForChallengeCalendar = [NSArray arrayWithArray:[self dotForChallengeCalendar:challengeCalendarDays]];
        
        for (int t = 0; t < [dtDotsForChallengeCalendar count]; t++) {
            NSLog(@"i: %d dot date: %@",t,[[dtDotsForChallengeCalendar objectAtIndex:t] dotDate]);
        }
        
        NSLog(@"challenge dog days");
    }
    
    return self;
}

- (NSArray*)dotForChallengeCalendar:(NSArray *)challengeDays
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
                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
                else {
                    //Make a dot for the state of "Participated but didn't complete"
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup someParticipationAndStillActiveColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    NSLog(@"-----------------------------------------------------");
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
                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    NSLog(@"-----------------------------------------------------");
                    [dotsForChallenge addObject:dot];
                }
                else {
                    //Make a dot for the state of "Participated but didn't complete"
                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                              andColorGroup:[DTDotColorGroup someParticipationButFailedColorGroup]
                                                                    andDate:((ChallengeDay*)[masterArray objectAtIndex:i]).day];
                    NSLog(@"the loop date: %@ the added date: %@ and position: %d", [masterArray  objectAtIndex:i],((ChallengeDay*)[masterArray objectAtIndex:i]).day,i);
                    NSLog(@"-----------------------------------------------------");
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
                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                NSLog(@"****************************************************");
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
                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                NSLog(@"****************************************************");
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
                NSLog(@"the loop date: %@ and position: %d", [masterArray  objectAtIndex:i],i);
                NSLog(@"****************************************************");
                [dotsForChallenge addObject:dot];
            }
        }
    }
    
    return dotsForChallenge;
}


- (NSArray*)buildChallengeCalendar:(NSInteger)forDuration
{
//    challengeDuration = [self.intent.challenge duration]; //[((Intent *)[self.intents objectAtIndex:indexPath.section]).challenge duration];
    NSArray *challengeDays = [[self.intent days] allObjects];  //((Intent *)[self.intents objectAtIndex:indexPath.section]).days;
    
    startDate = self.intent.starting;
    endDate = self.intent.ending;
    
    ///////// BUILD A LIST OF CHALLENGE DAY FOR CHALLENGE DURATION //////////////
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    NSMutableArray *datesForDuration = [NSMutableArray arrayWithObject:startDate];
    
    for (int i = 1; i <= forDuration; i++) {
        [offset setDay:i];
        NSDate *nextDay = [layoutCalendar dateByAddingComponents:offset toDate:startDate options:0];
        [datesForDuration addObject:nextDay];
    }
    //just the dates for duration verified at this point
    
    NSArray *safeArray = [NSArray arrayWithArray:datesForDuration];
    
    NSMutableArray *objectsToReplace = [[NSMutableArray alloc] init];
    NSMutableIndexSet *indexesToReplace = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i < [safeArray count]; i++ ) {
        for (int j = 0; j < [challengeDays count]; j++) {
            
            NSDate *challengeDayDate = (NSDate*)((ChallengeDay*)[challengeDays objectAtIndex:j]).day; //(NSDate*)((ChallengeDay*)[challengeDayArray objectAtIndex:j]).day;
            //                NSLog(@"the dates :%@", challengeDayDate);
            ChallengeDay *chalDay = (ChallengeDay*)[challengeDays objectAtIndex:j];
            NSDate *durationDate = (NSDate*)[safeArray objectAtIndex:i];
            //                NSLog(@"the dates :%@ and %@", challengeDayDate, durationDate);
            
            if ([layoutCalendar ojf_isDate:durationDate equalToDate:challengeDayDate withGranularity:NSDayCalendarUnit]) {
                //                    NSLog(@"challenge day: %@",chalDay);
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
    
    //one array and now the row logic ::sad face::

    
    
    
    return datesForDuration;
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

- (NSSet *)rowDatesAsSet
{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.row count]; i++) {
        NSLog(@"row: %d and date: %@",i,[(DTDotElement*)[self.row objectAtIndex:i] dotDate]);
        [dates addObject:[(DTDotElement*)[self.row objectAtIndex:i] dotDate]];
    }
    return [NSSet setWithArray:dates];
}

- (DTProgressRowEndStyle)endStyleForRow
{
    if ([self temporalStatusForRow] == DTProgressRowPast &&
        (![self.rowDateSet containsObject:self.intent.starting] && ![self.rowDateSet containsObject:self.intent.ending]) )
        return DTProgressRowEndFlat;
    if ([self temporalStatusForRow] == DTProgressRowCurrent && ![self.rowDateSet containsObject:self.intent.starting])
        return DTProgressRowEndFlatLeft;
    if ([self temporalStatusForRow] == DTProgressRowPast && [self.rowDateSet containsObject:self.intent.starting])
        return DTProgressRowEndFlatRight;
    if ([self temporalStatusForRow] == DTProgressRowCurrent && [self.rowDateSet containsObject:self.intent.starting])
        return DTProgressRowEndBothRounded;
    return DTProgressRowEndUndefined;
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
    CGFloat progressUnits; //length of progressElement coverage in discreet day-circle-units
    DTProgressColorGroup *progressColorGroup;
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)radius angleInDegrees:(double)angleInDegrees;

@end

@implementation DTProgressElement

@synthesize percent,leftCenter,rightCenter,radius;

static CGFloat END_PADDING = 3.f;
static CGFloat DOT_STROKE_WIDTH = 1.5f;

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
