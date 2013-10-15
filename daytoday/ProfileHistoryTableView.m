//
//  ProfileHistoryTableView.m
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProfileHistoryTableView.h"

#import "ProfileSectionHeaderView.h"

#import "Intent+D2D.h"
#import "Image+D2D.h"
#import "Challenge+D2D.h"
#import "ChallengeDay+D2D.h"

#import "DaysLeftTableCell.h"
#import "ProgressRowTableCell.h"
#import "ParticipantsRowTableCell.h"

#import "DTDotElement.h"
#import "DTDotColorGroup.h"
#import "NSCalendar+equalWithGranularity.h"

#import <UIColor+SR.h>

@implementation ProfileHistoryTableView
@synthesize intents;

static NSString *daysLeftCellReuseIdentifier = @"daysLeftCellReuseIdentifier";
static NSString *progressRowCellReuseIdentifier = @"progressRowCellReuseIdentifier";
static NSString *participantsRowCellReuseIdentifier = @"participantsRowCellReuseIdentifier";

static NSString *summaryProgressCellReuseIdentifier = @"summaryProgressCellIdentifier";
static NSString *sectionHeaderViewReuseIdentifier = @"sectionHeaderViewReuseIdentifier";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsVerticalScrollIndicator:NO];
        [self setContentInset:UIEdgeInsetsZero];
        [self setDelegate:self];
        [self setDataSource:self];
        
        [self registerClass:[DaysLeftTableCell class] forCellReuseIdentifier:daysLeftCellReuseIdentifier];
        [self registerClass:[ProgressRowTableCell class] forCellReuseIdentifier:progressRowCellReuseIdentifier];
        [self registerClass:[ParticipantsRowTableCell class] forCellReuseIdentifier:participantsRowCellReuseIdentifier];
        
        [self registerClass:[ProfileSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderViewReuseIdentifier];
    }
    return self;
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.intents && [self.intents count] > 0)
        return [self.intents count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DaysLeftTableCell *cell = (DaysLeftTableCell *)[tableView dequeueReusableCellWithIdentifier:daysLeftCellReuseIdentifier forIndexPath:indexPath];

        NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
        unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
        NSDateComponents *comps = [cal components:unitFlags fromDate:[NSDate date]  toDate:((Intent *)[self.intents objectAtIndex:indexPath.section]).ending  options:0];
        cell.daysLeft.text = [NSString stringWithFormat:@"%d",[comps day]];

        NSDateComponents *starting = [cal components:unitFlags fromDate:((Intent *)[self.intents objectAtIndex:indexPath.section]).starting];
        NSDateComponents *ending = [cal components:unitFlags fromDate:((Intent *)[self.intents objectAtIndex:indexPath.section]).ending];

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.locale = [NSLocale autoupdatingCurrentLocale];
        NSString *startingMonthName = [[df shortStandaloneMonthSymbols] objectAtIndex:([starting month]-1)];
        NSString *endingMonthName = [[df shortStandaloneMonthSymbols] objectAtIndex:([ending month]-1)];

//        NIDINFO(@"starting name %@",startingMonthName);
//        NIDINFO(@"ending name %@",endingMonthName);
//        NIDINFO(@"ending year %d",[ending year]);

        cell.monthSpan.text = [NSString stringWithFormat:@"%@ - %@ %d",[startingMonthName uppercaseString], [endingMonthName uppercaseString],[ending year]];
        return cell;
    }
    if (indexPath.row == 1) {
        ProgressRowTableCell *cell = (ProgressRowTableCell *)[tableView dequeueReusableCellWithIdentifier:progressRowCellReuseIdentifier forIndexPath:indexPath];

        NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
        
        NSNumber *challengeDuration = [((Intent *)[self.intents objectAtIndex:indexPath.section]).challenge duration];
        NSSet *participationDays = ((Intent *)[self.intents objectAtIndex:indexPath.section]).days;
        
        NSDate *startDate = ((Intent *)[self.intents objectAtIndex:indexPath.section]).starting;
//        NSDate *endDate = ((Intent *)[self.intents objectAtIndex:indexPath.section]).ending;
        
        ///////// BUILD A LIST OF CHALLENGE DAY FOR CHALLENGE DURATION //////////////
        NSDateComponents *offset = [[NSDateComponents alloc] init];
        NSMutableArray *allTheDates = [NSMutableArray arrayWithObject:startDate];
//        NIDINFO(@"the start date: %@",startDate);
        
        for (int i = 1; i < [challengeDuration intValue]; i++) {
            [offset setDay:i];
            NSDate *nextDay = [cal dateByAddingComponents:offset toDate:startDate options:0];
            [allTheDates addObject:nextDay];
        }
//        for (int i = 0; i < [allTheDates count]; i++) {
//            NSLog(@"the dates: %@",[allTheDates objectAtIndex:i]);
//        }
//        NSLog(@"the count: %d",[allTheDates count]);

        
        NSArray *challengeDayArray = [participationDays allObjects];
////
//        for (int i = 0; i < [challengeDayArray count]; i++) {
//            NSLog(@"the challenge dayes: %@",[(ChallengeDay*)[challengeDayArray objectAtIndex:i] day]);
//        }

        for (int i = 0; i < [allTheDates count]; i++ ) {
            for (int j = 0; j < [challengeDayArray count]; j++) {
                
                NSDate *challengeDayDate = (NSDate*)[(ChallengeDay*)[challengeDayArray objectAtIndex:j] day];
//                NSLog(@"the dates :%@", challengeDayDate);

                NSDate *durationDate = [allTheDates objectAtIndex:i];
//                NSLog(@"the dates :%@ and %@", challengeDayDate, durationDate);
                
                if ([cal ojf_isDate:durationDate
                        equalToDate:challengeDayDate
                    withGranularity:NSDayCalendarUnit]) {
                    [allTheDates replaceObjectAtIndex:i withObject:challengeDayDate];
                }
            }
        }
        
        for (int i = 0; i < [allTheDates count]; i++) {
            if ([[allTheDates objectAtIndex:i] class] == [ChallengeDay class]) {
                NSLog(@"i: %d and Challenge day with date: %@",i,[(ChallengeDay*)[allTheDates objectAtIndex:i] day]);
            }else {
                NSLog(@"i: %d and date: %@",i,[allTheDates objectAtIndex:i]);
            }
        }
        
        
        
        NSArray *masterArray = [NSArray arrayWithArray:allTheDates];
        
        
//        NSSortDescriptor *sortDaysDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES];
//        NSArray *sortedChallengeDays = [partDays sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDaysDescriptor]];
////        NIDINFO(@"sorted array: %@",sortedChallengeDays);
//        
//        NSMutableArray *dotsForDuration = [[NSMutableArray alloc] initWithCapacity:[allTheDates count]];
//        
//        NSArray *durationDatesArray = [NSArray arrayWithArray:[allTheDates allObjects]];
//        NSSortDescriptor *sortDurationDatesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
//        NSArray *sortedDurationDates = [durationDatesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDurationDatesDescriptor]];
        
//        NIDINFO(@"the sorted duration dates :%@", theSortedDurationDates);
//        NIDINFO(@"date day: %@", ((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day);
//        NIDINFO(@"been there %d",[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]);

//        NIDINFO(@"the duration date set count :%d", [allTheDates count]);
//        NIDINFO(@"the sorted duration date count :%d", [sortedDurationDates count]);
//        NIDINFO(@"the sorted challenge date count :%d", [sortedChallengeDays count]);

        NSDate *today = [NSDate date];

//        NSMutableDictionary *weekRowsDict = [[NSMutableDictionary alloc] init];
//        NSNumber *rowKey = [NSNumber numberWithInt:0];
        
//        for (int i = 0; i < [allTheDates count]; i++) {
//            //check if day is the day today
//            if ([cal ojf_isDate:([sortedDurationDates objectAtIndex:i])
//                    equalToDate:today
//                withGranularity:NSDayCalendarUnit]) {
////                NIDINFO(@"this is the day today: %@ today: %@",[sortedDurationDates objectAtIndex:i],today);
//
//                //If there is a ChallengeDay for TODAY then the possible states are:
//                //challenge day completed
//                //participated but did not complete (partial completion view opportunity)
//                //and active day dot but no completion
//                if ( i < [sortedChallengeDays count]) {
//                    if ([allTheDates containsObject:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day]) {
//                        if ([((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).completed boolValue]) {
//                            //Make a dot for participated and did complete
////                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
//                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                                      andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
//                                                                          andDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day];
//                            NSLog(@"the loop date: %@ the added date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day,i);
//                            NSLog(@"-----------------------------------------------------");
//                            [dotsForDuration addObject:dot];
//                        }
//                        else {
//                            //Make a dot for the state of "Participated but didn't complete"
////                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
//                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                                      andColorGroup:[DTDotColorGroup someParticipationAndStillActiveColorGroup]
//                                                                            andDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day];
//                            NSLog(@"the loop date: %@ the added date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day,i);
//                            NSLog(@"-----------------------------------------------------");
//                            [dotsForDuration addObject:dot];
//                        }
//                    }
//                }
//                else{
//                    //Make a dot for the active state of the day today and there is no participation for the day today
////                    NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:[sortedDurationDates objectAtIndex:i]] day] ];
//                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                              andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
//                                                                  andDate:[sortedDurationDates objectAtIndex:i]];
//                    NSLog(@"the loop date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],i);
//                    NSLog(@"****************************************************");
//                    [dotsForDuration addObject:dot];
//                }
//            }
//
//            //check dates in the past
//            if ([cal ojf_compareDate:[sortedDurationDates objectAtIndex:i]
//                              toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending) {
////                NIDINFO(@"these are in the past: %@ today: %@",[sortedDurationDates objectAtIndex:i],today);
//                //If there is a challenge day for the past then the possible states are:
//                //failed
//                //participated but did not complete (failed but with some effort)
//                //just didn't participate at all -- complete and utter failure
//                if ( i < [sortedChallengeDays count]) {
//                    if ([allTheDates containsObject:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day]) {
//                        if ([((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).completed boolValue]) {
//                            //Make a dot for participated and did complete
////                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
//                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                                      andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
//                                                                            andDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day];
//                            NSLog(@"the loop date: %@ the added date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day,i);
//                            NSLog(@"-----------------------------------------------------");
//                            [dotsForDuration addObject:dot];
//                            [dotsForDuration addObject:dot];
//                        }
//                        else {
//                            //Make a dot for the state of "Participated but didn't complete"
////                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
//                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                                      andColorGroup:[DTDotColorGroup someParticipationButFailedColorGroup]
//                                                                            andDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day];
//                            NSLog(@"the loop date: %@ the added date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day,i);
//                            NSLog(@"-----------------------------------------------------");
//                            [dotsForDuration addObject:dot];
//                            [dotsForDuration addObject:dot];
//                        }
//                    }
//                }
//                else{
//                    //Make a dot for failure state because you can't just up and change the past
////                    NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:[sortedDurationDates objectAtIndex:i]] day] ];
//                    DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                              andColorGroup:[DTDotColorGroup failedDayColorGroup]
//                                                                    andDate:[sortedDurationDates objectAtIndex:i]];
//                    NSLog(@"the loop date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],i);
//                    NSLog(@"****************************************************");
//                    [dotsForDuration addObject:dot];
//                }
//                
//            }
//
//            //check and handle all future dates
//            if ([cal ojf_compareDate:[sortedDurationDates objectAtIndex:i]
//                              toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
////                NIDINFO(@"these are in the future: %@ today: %@",[sortedDurationDates objectAtIndex:i],today);
//                //The future is simple because it's just chock full of opportunity
//                //make a dot for the state of "USER HAS NOT PARTICIPATED"
////                NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:[sortedDurationDates objectAtIndex:i]] day] ];
//                DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                          andColorGroup:[DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup]
//                                                                andDate:[sortedDurationDates objectAtIndex:i]];
//                NSLog(@"the loop date: %@ and position: %d", [sortedDurationDates  objectAtIndex:i],i);
//                NSLog(@"****************************************************");
//                [dotsForDuration addObject:dot];
//            }
//        }

//        NSArray *testArray = [NSArray arrayWithArray:dotsForDuration];
//        
//        NSMutableArray *arrayOfArrays = [NSMutableArray array];
//        
//        int itemsRemaining = [testArray count];
//        int aa = 0;
//        
//        while(aa < [testArray count]) {
//            NSRange range = NSMakeRange(aa, MIN(7, itemsRemaining));
//            NSArray *subarray = [testArray subarrayWithRange:range];
//            [arrayOfArrays addObject:subarray];
//            itemsRemaining-=range.length;
//            aa+=range.length;
//        }
//        
//        for (int qq = 0; qq < [arrayOfArrays count]; qq++) {
//            for (int q1 = 0; q1 < [[arrayOfArrays objectAtIndex:qq] count]; q1++) {
//                NSLog(@"%@", [[[arrayOfArrays objectAtIndex:qq] objectAtIndex:q1] dotDate]);
//            }
//        }
//        
//        for (int t = 0; t < [dotsForDuration count]; t++) {
//            NSLog(@"something else: %@", [[dotsForDuration objectAtIndex:t] dotDate]);
//        }
//        
//        NSLog(@"even more");
        
//        for (NSString* key in [weekRowsDict allKeys] ) {
//            NIDINFO(@"the key: %@ and the row: %@",key,[weekRowsDict objectForKey:key]);
//        }
        
//        [weekRowsDict enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
//            NIDINFO(@"the key: %@ and the row: %@",key,object);
//        }];


//        - (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

        
        ////////////// TEST DT ELEMENT FILTER ///////////////
//        for (int q = 0 ; q < [dotsForDuration count]; q++) {
//            NIDINFO(@"dotsforduration DATE: %@", [[dotsForDuration objectAtIndex:q] dotDate]);
//        }
        
        
        ////////// BREAK APART DOTS INTO WEEK-ROWS /////////////
//        NSMutableArray *weekRows = [NSArray splitArray:dotsForDuration componentsPerSegment:7];
//        NSMutableArray *weekRows = [NSMutableArray arrayWithArray:[NSArray splitArray:dotsForDuration componentsPerSegment:7]];

//        for (int z = 0; z < [weekRows count]; z++) {
//            for (int y = 0; y < [[weekRows objectAtIndex:z] count]; y++) {
//                NIDINFO(@"test some bs happening DATE: %@",[[[weekRows objectAtIndex:z] objectAtIndex:y] dotDate]);
//            }
//        }
        
        
        ////////// PAD WEEK ROWS WITH EXTRA DAYS UNTIL ROW IS FULL //////////
//        for (int i = 0; i < [weekRows count]; i++) {
//            if ([[weekRows objectAtIndex:i] count] < 7) {
////                NIDINFO(@"this is the weekrow that needs to be padded: %@", [weekRows objectAtIndex:i]);
//                //this week-row needs to be padded and replaced
//                int indexToReplace = i;
//                
//                //grab dot number from previous dot and extend into the future to pad the week-row
//                NSMutableArray *paddedWeekRow = [NSMutableArray arrayWithArray:[weekRows objectAtIndex:i]];
//                DTDotElement *lastDot = [paddedWeekRow lastObject];
//                
//                NSDateComponents *paddedOffSetComponent = [cal components:NSCalendarUnitDay fromDate:lastDot.dotDate];
//
//                for (int j = 1; [paddedWeekRow count] < 7; j++) {
//                    [paddedOffSetComponent setDay:j];
//                    NSDate *paddedDate = [cal dateByAddingComponents:paddedOffSetComponent toDate:lastDot.dotDate options:0];
//                    DTDotElement *paddedFutureDot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
//                                                              andColorGroup:[DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup]
//                                                                    andDate:paddedDate];
//                    [paddedWeekRow addObject:paddedFutureDot];
//                }
//                [weekRows replaceObjectAtIndex:indexToReplace withObject:paddedWeekRow];
//            }
//        }

        ////////// TEST PADDED WEEK ROWS ///////////////
//        for (int i = 0; i < [weekRows count]; i++) {
//            NIDINFO(@"weekrow count: %d",[[weekRows objectAtIndex:i] count]);
////            NIDINFO(@"week row %d %@ and date: %@",i,[weekRows objectAtIndex:i],((DTDotElement*)[weekRows objectAtIndex:i]).dotDate);
//            for (int j = 0; j < [[weekRows objectAtIndex:i] count]; j ++) {
//                NIDINFO(@"week row %d and date: %@",i,[[[weekRows objectAtIndex:i] objectAtIndex:j] dotDate]);
//            }
//        }
        ////pASSes for now

        
        ////////// DETERMINE ROW QUALITIES ///////////// --> THESE WILL BE ROW STYLES
        //DTProgressRowStyleFlat            --> if entire row is a past row
        //DTProgressRowStyleFlatLeft        --> if row contains current day and the last row is a past row
        //DTProgressRowStyleFlatRight       --> if row contains current day and the current row is in the past
        //DTProgressRowStyleRounded         --> if row contains current day and current row is the only row

//        for (int i = 0; i < [weekRows count]; i++ ) {
//            NSIndexSet *indexes = [[weekRows objectAtIndex:i] indexesOfObjectsPassingTest:^BOOL(DTDotElement *obj, NSUInteger idx, BOOL *stop) {
//                NIDINFO(@"the BOOL: %d and the date: %@",[cal ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit],obj.dotDate);
//                return ([cal ojf_isDate:obj.dotDate equalToDate:today withGranularity:NSDayCalendarUnit]);
//            }];
//            NSLog(@"OooooooooooooooooooooooooooooooO");
//            NSArray *results = [[weekRows objectAtIndex:i] objectsAtIndexes:indexes];
//
//            for (int j = 0; j < [results count]; j++) {
//                NIDINFO(@"object at index: %@",[results objectAtIndex:j]);
//            }
    
//            NIDINFO(@"the indexes %@",indexes);
//            NSRange weekRange = {0,6};
//            NIDINFO(@"the indexes: %d",[indexes count]);
//            NIDINFO(@"is there a today day in one of these?: BOOL: %d, and week-row: %d",[indexes containsIndexesInRange:weekRange],i);
//        }
        
        //- (BOOL)containsIndexesInRange:(NSRange)range;
        //NSRange NSMakeRange(NSUInteger loc, NSUInteger len)
                            

//             NSIndexSet *targetIndices = [array indexesOfObjectsPassingTest:^ BOOL (id obj, NSUInteger idx, BOOL *stop) {
//                return [obj isEqual:target];
//            }];

//             NSIndexSet *indexes = [recipeArray indexesOfObjectsPassingTest:^BOOL (id el, NSUInteger i, BOOL *stop) {
//                                        NSString *recipeID = [(Recipe *)el recipe_id];
//                                        return [keyArray containsObject:recipeID];
//                                    }];
//             NSArray *results = [recipeArray objectsAtIndexes:indexes];


//        - (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
//        - (BOOL)containsIndexesInRange:(NSRange)indexRange


//        NIDINFO(@"created dots for all the week rows count: %d", [dotsForDuration count]);
//        NIDINFO(@"week row count: %d", [weekRows count]);
//        NIDINFO(@"week row 1 %@", [weekRows objectAtIndex:0]);


        //get week rows for duration
        //check row status
        //for instance - is the row the top displayed row or the bottom displayed row
        //is row a START ROW, a PAST ROW or ACTIVE DAY ROW
        //draw rows for status included if the day was accomplished or not
        return cell;
    }
    if (indexPath.row == 2) {
        ParticipantsRowTableCell *cell = (ParticipantsRowTableCell *)[tableView dequeueReusableCellWithIdentifier:participantsRowCellReuseIdentifier forIndexPath:indexPath];
        return cell;
    }
    else {
        //doing this to shut the warnings up
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"generic"];
        return  cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
        return 87.f;
    if (indexPath.row == 2)
        return 45.f;
    else
        return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProfileSectionHeaderView *sectHeaderView = (ProfileSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewReuseIdentifier];
    sectHeaderView.challengeLabel.text = [((Intent *)[self.intents objectAtIndex:section]).challenge name];
//    [sectHeaderView.sectionImageView setPathToNetworkImage: ((Image *)[((Intent *)[self.intents objectAtIndex:section]).challenge.image anyObject]).url
//                                            forDisplaySize: CGSizeMake(320., 140.)
//                                               contentMode: UIViewContentModeScaleAspectFill];
    
    [sectHeaderView.sectionImageView setPathToNetworkImage: @"http://daytoday-dev.s3.amazonaws.com/images/a0e2d3d7813b495181f56a7f528012a8.jpeg"
                                            forDisplaySize: CGSizeMake(320., 110.)
                                               contentMode: UIViewContentModeScaleAspectFill];
    
    return sectHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
