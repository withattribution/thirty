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

@interface DTChallengeCalendar () {
  NSCalendar *_localCalendar;
}

@property (nonatomic,strong) NSArray *intentDates;
@property (nonatomic,strong) NSArray *challengeDots;
@property (nonatomic,strong) NSArray *challengeCalendarDates;
@property (nonatomic,strong) NSArray *rows;
@property (nonatomic,strong) NSArray *progressRows;

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

@end

static int NUM_DAYS_FOR_ROW = 7;
static CGFloat EDGE_PADDING = 3.f;

@implementation DTChallengeCalendar

+ (DTChallengeCalendar *)calendarWithIntent:(PFObject *)intent
{
  DTChallengeCalendar *challengeCalendar = [[DTChallengeCalendar alloc] initWithIntent:intent];
  return challengeCalendar;
}

- (id)initWithIntent:(PFObject *)intent
{
  self = [super init];
  if (self) {
    
    self.startDate = [intent objectForKey:kDTIntentStartingKey];
    self.endDate = [intent objectForKey:kDTIntentEndingKey];
    
    _localCalendar = [NSCalendar autoupdatingCurrentCalendar];
    
    self.intentDates = [self datesForIntent:intent];
    self.challengeCalendarDates = [self padCalendarIfNecessary:intent];
    self.challengeDots = [self buildChallengeDotsForIntent:intent];
    self.rows = [self weekRows];
    self.progressRows = [self progressRowsFromWeekRows];
  }
  return self;
}

- (NSArray *)datesForIntent:(PFObject *)intent
{
  NSDate *starting = [intent objectForKey:kDTIntentStartingKey];
  
  NSDateComponents *offSetComp = [_localCalendar components:(NSCalendarUnitDay)
                                                   fromDate:starting];
  
  NSMutableArray *dates = [NSMutableArray arrayWithObject:starting];
  NSArray *challengeDaysFromIntent = [intent objectForKey:kDTIntentChallengeDays];

  for (int iterator = 1; iterator < [challengeDaysFromIntent count]; iterator++) {
    [offSetComp setDay:iterator];
    
    NSDate *offsetDate = [_localCalendar dateByAddingComponents:offSetComp toDate:starting options:0];
    [dates addObject:offsetDate];
  }
  
//  for (int i = 0; i < [dates count]; i++) {
////    NIDINFO(@"the date: %@",[dates objectAtIndex:i]);
//    NIDINFO(@"the string for day: %@",[[DTCommonUtilities displayDayFormatter] stringFromDate:[dates objectAtIndex:i]]);
//  }
//
//  NIDINFO(@"the count: %d",[dates count]);

  return dates;
}

- (NSArray *)padCalendarIfNecessary:(PFObject *)intent
{
  //add dates to the end of the intent days in order to facilitate
  //the division of the calendar into rows (of NUM_DAYS_FOR_ROW length)
  NSMutableArray *paddedCalendarDates = [NSMutableArray arrayWithArray:self.intentDates];
  
  int mod = [self.intentDates count] % NUM_DAYS_FOR_ROW;
  
  if (mod != 0) {
    int toAdd = NUM_DAYS_FOR_ROW - mod;
    
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:toAdd];
    
    NSDateComponents *offSetComp = [_localCalendar components:(NSCalendarUnitDay)
                                                     fromDate:[intent objectForKey:kDTIntentEndingKey]];
    for (int iterator = 1; iterator <= toAdd; iterator++) {
      
      [offSetComp setDay:iterator];
      
      NSDate *offsetDate = [_localCalendar dateByAddingComponents:offSetComp toDate:[intent objectForKey:kDTIntentEndingKey] options:0];
      [dates addObject:offsetDate];
    }
    
    [paddedCalendarDates addObjectsFromArray:dates];
    
//    for (int i = 0; i < [paddedCalendarDates count]; i++) {
//      NIDINFO(@"the string for padded: %@",[[DTCommonUtilities displayDayFormatter] stringFromDate:[paddedCalendarDates objectAtIndex:i]]);
//    }
//    NIDINFO(@"padded dates: %d",[paddedCalendarDates count]);
  }
  
  return paddedCalendarDates;
}

- (NSArray *)buildChallengeDotsForIntent:(PFObject *)intent
{
  NSMutableArray *dots = [NSMutableArray arrayWithCapacity:[self.challengeCalendarDates count]];

  NSArray *challengeDays = [intent objectForKey:kDTIntentChallengeDays];
  for (int i = 0; i < [self.challengeCalendarDates count]; i++) {
    
    //handle case where challenge days have been padded for rows of NUM_DAYS_FOR_ROW length
    DTDotElement * dot = [DTDotElement buildForChallengeDay:(i < [challengeDays count]) ? [challengeDays objectAtIndex:i] : nil
                                                    andDate:[self.challengeCalendarDates objectAtIndex:i]];
    [dots addObject:dot];
  }
  
//  for (int i = 0; i < [dots count]; i++) {
//    NIDINFO(@"the dots %@",[[dots objectAtIndex:i] dotDate]);
//  }
//  NIDINFO(@"dots count: %d",[dots count]);
  
  return dots;
}

- (NSArray *)weekRows
{
  //break apart dtDotCalendar array into subarrays of 7 day long week-rows
  NSArray *swapArray = [NSArray arrayWithArray:self.challengeDots];
  NSMutableArray *arrayOfWeeks = [NSMutableArray array];
  
  int itemsRemaining = [swapArray count];
  int aa = 0;
  
  while(aa < [swapArray count]) {
    NSRange range = NSMakeRange(aa, MIN(NUM_DAYS_FOR_ROW, itemsRemaining));
    NSArray *subarray = [swapArray subarrayWithRange:range];
    [arrayOfWeeks addObject:subarray];
    itemsRemaining -= range.length;
    aa+=range.length;
  }
  
//  for (int i = 0; i < [arrayOfWeeks count]; i++) {
//    NIDINFO(@"the weeks %@",[arrayOfWeeks objectAtIndex:i]);
//    for (int j = 0; j < [arrayOfWeeks count]; j++) {
//      NIDINFO(@"the dots %@",[[arrayOfWeeks objectAtIndex:i] objectAtIndex:j]);
//    }
//  }
//  NIDINFO(@"weeks count: %d",[arrayOfWeeks count]);
  
  return arrayOfWeeks;
}

- (NSArray *)progressRowsFromWeekRows
{
  NSMutableArray *prows = [[NSMutableArray alloc] initWithCapacity:[self.rows count]];
  
  for(int i = 0; i < [self.rows count]; i++){
    DTProgressRowTemporalStatus status = [self temporalStatusForRow:[self.rows objectAtIndex:i]];
    DTProgressRowEndStyle style = [self endStyleForRow:[self.rows objectAtIndex:i]];
    [prows addObject:[DTProgressRow withEndStyle:style phase:status row:[self.rows objectAtIndex:i]]];
  }
  
  return prows;
}

- (DTProgressRowTemporalStatus)temporalStatusForRow:(NSArray *)row
{
  NSDate *today = [NSDate date];
  
  //test if all indexes in weekrow evaluate to a past date
  NSIndexSet *past = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
    return ([_localCalendar ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending);
  }];
  
  if ([past count] == [row count]) {
    //one index contains the current date so entire row is the current row
    return DTProgressRowPast;
  }
  
  //test if any indexes in weekrow evaluate to a today's date
  NSIndexSet *current = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
    return ([_localCalendar ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
  }];
  
  if ([current count] == 1) {
    //one index contains the current date so entire row is the current row
    return DTProgressRowCurrent;
  }
  
  //test if all indexes in weekrow evaluate to a future date
  NSIndexSet *future = [row indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
    return ([_localCalendar ojf_compareDate:obj.dotDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending);
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
      (![rowSet containsObject:self.startDate] && ![rowSet containsObject:self.startDate]) )
    return DTProgressRowEndFlat;
  if ([self temporalStatusForRow:row] == DTProgressRowCurrent && ![rowSet containsObject:self.startDate])
    return DTProgressRowEndFlatLeft;
  if ([self temporalStatusForRow:row] == DTProgressRowPast && [rowSet containsObject:self.startDate])
    return DTProgressRowEndFlatRight;
  if ([self temporalStatusForRow:row] == DTProgressRowCurrent && [rowSet containsObject:self.startDate])
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
      return ([_localCalendar ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
    }];
    return ([currentDayIndex firstIndex]+1)*40.f; //Generic DTDotElement frame width = 40.f
  }else {
    return 320.f; //full width -- doesn't really matter though since this is only used if the endstyle is not flat aka DTProgressRowCurrent
  }
}

- (DTDotElement *)withDate:(NSDate *)d
{
  DTDotElement *dot = nil;
  
  for (int i = 0; i < [self.progressRows count]; i++) {
    NSIndexSet *dotIndex = [[[self.progressRows objectAtIndex:i] weekRow] indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
      return ([_localCalendar ojf_isDate:obj.dotDate equalToDate:d withGranularity:NSDayCalendarUnit]);
    }];
    if ([dotIndex count] > 0) {
      dot = [[[self.progressRows objectAtIndex:i] weekRow] objectAtIndex:[dotIndex firstIndex]];
      return dot;
    }
    
  }
  return dot;
}

//FROZEN SUMMARY VIEW FOR NOW
//- (UIView *)summaryProgressView
//{
//  DTDotElement *startDot = [self withDate:self.startDate];
//  DTDotElement *endDot = [self withDate:self.endDate];
//  
//  DTProgressElement *summaryElement = [[DTProgressElement alloc] initForSummaryElement:self.intent.percentCompleted];
//  
//  [startDot setCenter:[summaryElement leftCenter]];
//  [endDot setCenter:[summaryElement rightCenter]];
//  
//  [summaryElement addSubview:startDot];
//  [summaryElement addSubview:endDot];
//  
//  return summaryElement;
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

- (id)initForSummaryElement:(CGFloat)p
{
    CGRect GENERIC_PROGRESS_FRAME = CGRectMake(0.f, 0.f, 320.f, 40.f);
    self = [super initWithFrame:GENERIC_PROGRESS_FRAME];
    if (self) {
        self.percent = p;
        
        progressColorGroup = [DTProgressColorGroup summaryProgressBackground];
        
        [self determineRoundedRadius];
        progressUnits = [self convertPercentToProgressUnits:1.0];
        [self drawRoundedProgressElement];
        
        progressUnits = [self convertPercentToProgressUnits:p];
        progressColorGroup = [DTProgressColorGroup summaryProgressForeground];
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
