//
//  DTChallengeCalendar.m
//  daytoday
//
//  Created by pasmo on 12/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTChallengeCalendar.h"

#define DEFAULT_ROW_LENGTH 7

@interface DTChallengeCalendar () {
  NSCalendar *localCalendar;
}

/*the current array of challenge days in purely ordinal form*/
@property (nonatomic,strong) NSArray *challengeDays;

/*all the dates for the current challenge oridinal days as related to calendar dates*/
@property (nonatomic,strong) NSArray *challengeDates;

/*all the dates for the current challenge plus extra days for*/
/*the purpose of building out DTProgressRows*/
@property (nonatomic,strong) NSArray *paddedChallengeDates;

/*challenges days organized into standard lengths for DTProgressRows*/
@property (nonatomic,strong) NSArray *rows;

@property (nonatomic,strong) PFObject *intent;

@property (nonatomic,assign) NSUInteger rowLength;

@end

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
    localCalendar = [DTCommonUtilities commonCalendar];
    
    _rowLength =  DEFAULT_ROW_LENGTH;
    self.intent = intent;
  
    self.startDate = [self.intent objectForKey:kDTIntentStartingKey];
    self.endDate   = [self.intent objectForKey:kDTIntentEndingKey];
    
    [self buildChallengeCalendar];
  }
  return self;
}

- (void)setProgressRowLength:(NSUInteger)length
{
  _rowLength = length;
}

- (void)buildChallengeCalendar
{
  _challengeDates = [self challengeDates];
  self.paddedChallengeDates = [self paddedChallengeDates];
  self.rows = [self rows];
}

- (NSArray *)challengeDates
{
  NSDateComponents *offSetComp = [localCalendar components:(NSCalendarUnitDay) fromDate:self.startDate];
  NSMutableArray *dates = [NSMutableArray arrayWithObject:self.startDate];
  for (int iterator = 1; iterator < [self.challengeDays count]; iterator++)
  {
    [offSetComp setDay:iterator];
    NSDate *offsetDate = [localCalendar dateByAddingComponents:offSetComp toDate:self.startDate options:0];
    [dates addObject:offsetDate];
  }
  //  for (int i = 0; i < [dates count]; i++) {
  ////    NIDINFO(@"the date: %@",[dates objectAtIndex:i]);
  //    NIDINFO(@"the string for day: %@",[[DTCommonUtilities displayDayFormatter] stringFromDate:[dates objectAtIndex:i]]);
  //  }
  //  NIDINFO(@"the count: %d",[dates count]);
  return dates;
}

- (NSArray *)paddedChallengeDates
{
  //add dates to the end of the intent days in order to facilitate
  //the division of the calendar into rows (of NUM_DAYS_FOR_ROW length)
  NSMutableArray *paddedCalendarDates = [NSMutableArray arrayWithArray:self.challengeDates];
  
  NSInteger mod = [self.challengeDates count] % self.rowLength;
  
  if (mod != 0) {
    NSUInteger toAdd = self.rowLength - mod;
    
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:toAdd];
    NSDateComponents *offSetComp = [localCalendar components:(NSCalendarUnitDay)
                                                    fromDate:self.endDate];
    for (int iterator = 1; iterator <= toAdd; iterator++)
    {
      [offSetComp setDay:iterator];
      NSDate *offsetDate = [localCalendar dateByAddingComponents:offSetComp
                                                          toDate:self.endDate/*[intent objectForKey:kDTIntentEndingKey]*/ options:0];
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

-(NSArray *)rows
{
  //break apart dtDotCalendar array into subarrays of NUM_DAYS_FOR_ROW length rows
  NSArray *swapArray = [NSArray arrayWithArray:self.paddedChallengeDates];
  NSMutableArray *arrayOfWeeks = [NSMutableArray array];
  
  NSUInteger itemsRemaining = [swapArray count];
  NSUInteger aa = 0;
  
  while(aa < [swapArray count]) {
    NSRange range = NSMakeRange(aa, MIN(self.rowLength, itemsRemaining));
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

- (NSArray *)challengeDays
{
  return [[DTCache sharedCache] challengeDaysForIntent:self.intent];
}

#pragma mark DTProgressRow DataSource Methods

- (NSUInteger)numberOfDaysForProgressRow:(DTProgressRow *)row
{
  return _rowLength;
}

- (NSUInteger)indexForDate:(DTProgressRow *)row date:(NSDate *)date
{
  NSUInteger indexForDate = NSIntegerMax;
  for (int i = 0; i < [self.rows count]; i++) {
    indexForDate = [[self.rows objectAtIndex:i] indexOfObjectPassingTest:^BOOL(NSDate *dateObj, NSUInteger idx, BOOL *stop){
      //      NIDINFO(@"the equality: %d and idx: %d", [localCalendar ojf_isDate:dateObj equalToDate:date withGranularity:NSDayCalendarUnit], idx);
      if ([localCalendar isDate:dateObj equalToDate:date toUnitGranularity:NSDayCalendarUnit]) {
        *stop = YES;
        return YES;
      }else {
        return NO;
      }
    }];
    if(indexForDate < NSIntegerMax){
      return indexForDate;
    }
//    NIDINFO(@"the index: %d",indexForDate);
  }
  //if the active date is somehow not in the progress row -- do no harm
  return 0;
}

- (NSArray *)datesForProgressRow:(DTProgressRow *)row date:(NSDate *)date
{
  return [self rowForDate:date];
}

- (NSArray *)challengeDaysForProgressRow:(DTProgressRow *)row date:(NSDate *)date
{
  NSArray *progressRowDates = [self rowForDate:date];
//  NIDINFO(@"progress row dates: %ld", [progressRowDates count]);
  
  NSMutableArray *challengeDaysForRow = [[NSMutableArray alloc] init];
  for (int i = 0; i < [progressRowDates count]; i++) {
    [challengeDaysForRow addObject:[[DTCache sharedCache] challengeDayForDate:[progressRowDates objectAtIndex:i]
                                                                       intent:self.intent]];
    //block off effect of having padded dates -- this is because we used to show
    //dates instead of just the ordinal numbers which we will move to shortly
    if ([[DTCommonUtilities commonCalendar] compareDate:[progressRowDates objectAtIndex:i]
                                                 toDate:self.endDate
                                      toUnitGranularity:NSCalendarUnitDay] == NSOrderedSame) {
      break;
    }
  }
  return challengeDaysForRow;
}

- (NSArray *)rowForDate:(NSDate *)date
{
  NSUInteger index = NSIntegerMax;
#warning i secretly want to clean this up (not a priority though)
  for (int i = 0; i < [self.rows count]; i++) {
    index = [[self.rows objectAtIndex:i] indexOfObjectPassingTest:^BOOL(NSDate *dateObj, NSUInteger idx, BOOL *stop){
      if ([localCalendar isDate:dateObj equalToDate:date toUnitGranularity:NSDayCalendarUnit]) {
        *stop = YES;
        return YES;
      }else {
        return NO;
      }
    }];
    if(index < NSIntegerMax){
      return [self.rows objectAtIndex:i];
    }
//    NIDINFO(@"the index: %d",index);
  }
  return [NSArray array];
}

- (DTProgressRowTemporalStatus)temporalStatusForDateRow:(NSArray *)row
{
  NSDate *today = [NSDate date];
  //test if all indexes in weekrow evaluate to a past date
  NSIndexSet *past = [row indexesOfObjectsPassingTest:^BOOL(NSDate *objDate, NSUInteger idx, BOOL *stop) {
    return ([localCalendar compareDate:objDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending);
  }];

  if ([past count] == [row count]) {
    //one index contains the current date so entire row is the current row
    return DTProgressRowPast;
  }

  //test if any indexes in weekrow evaluate to a today's date
  NSIndexSet *current = [row indexesOfObjectsPassingTest:^BOOL(NSDate *objDate, NSUInteger idx, BOOL *stop) {
    return ([localCalendar isDate:objDate equalToDate:today toUnitGranularity:NSDayCalendarUnit]);
  }];

  if ([current count] == 1) {
    //one index contains the current date so entire row is the current row
    return DTProgressRowCurrent;
  }

  //test if all indexes in weekrow evaluate to a future date
  NSIndexSet *future = [row indexesOfObjectsPassingTest:^BOOL(NSDate *objDate, NSUInteger idx, BOOL *stop) {
    return ([localCalendar compareDate:objDate toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending);
  }];

  if ([future count] == [row count]) {
    //one index contains the current date so entire row is the current row
    return DTProgressRowFuture;
  }
  return DTProgressRowTemporalStatusUndefined;
}

- (DTProgressRowEndStyle)endStyleForProgressRow:(DTProgressRow *)row date:(NSDate *)date
{
  NSArray *dateRow = [self rowForDate:date];
  NSSet *rowSet = [NSSet setWithArray:dateRow];
  if ([self temporalStatusForDateRow:dateRow] == DTProgressRowPast &&
      (![rowSet containsObject:self.startDate] && ![rowSet containsObject:self.startDate]) )
    return DTProgressRowEndFlat;
  if ([self temporalStatusForDateRow:dateRow] == DTProgressRowCurrent && ![rowSet containsObject:self.startDate])
    return DTProgressRowEndFlatLeft;
  if ([self temporalStatusForDateRow:dateRow] == DTProgressRowPast && [rowSet containsObject:self.startDate])
    return DTProgressRowEndFlatRight;
  if ([self temporalStatusForDateRow:dateRow] == DTProgressRowCurrent && [rowSet containsObject:self.startDate])
    return DTProgressRowEndBothRounded;
  return DTProgressRowEndUndefined;
}

@end
