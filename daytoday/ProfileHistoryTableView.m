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
        
        NSNumber *duration = [((Intent *)[self.intents objectAtIndex:indexPath.section]).challenge duration];
        NSSet *participationDays = ((Intent *)[self.intents objectAtIndex:indexPath.section]).days;
        
        NSDate *startDate = ((Intent *)[self.intents objectAtIndex:indexPath.section]).starting;
        NSDate *endDate = ((Intent *)[self.intents objectAtIndex:indexPath.section]).ending;
        
        NSDateComponents *offset = [[NSDateComponents alloc] init];
        NSMutableSet *allTheDates = [NSMutableSet setWithObject:startDate];
        NIDINFO(@"the start date: %@",startDate);
        
        for (int i = 1; i < [duration intValue]; i++) {
            [offset setDay:i];
            NSDate *nextDay = [cal dateByAddingComponents:offset toDate:startDate options:0];
            [allTheDates addObject:nextDay];
        }
        
        NSArray *partDays = [participationDays allObjects];
        NIDINFO(@"participations days count: %d",[partDays count]);
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES];
        NSArray *sortedChallengeDays = [partDays sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
        //        NIDINFO(@"sorted array: %@",sortedChallengeDays);
        
        NSMutableArray *dotsForDuration = [[NSMutableArray alloc] initWithCapacity:[allTheDates count]];
        
        NSArray *durationDatesArray = [NSArray arrayWithArray:[allTheDates allObjects]];
        
        NSSortDescriptor *durationDatesArraryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
        NSArray *theSortedDurationDates = [durationDatesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:durationDatesArraryDescriptor]];
        
        NIDINFO(@"the sorted duration dates :%@", theSortedDurationDates);
        
//NIDINFO(@"date day: %@", ((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day);
//NIDINFO(@"been there %d",[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]);
        
        NSDate *today = [NSDate date];
        
        for (int i = 0; i < [allTheDates count]; i++) {
            //check if day is the day today
            if ([cal ojf_isDate:((NSDate*)[theSortedDurationDates objectAtIndex:i])
                    equalToDate:today
                withGranularity:NSDayCalendarUnit]) {
                //If there is a ChallengeDay for TODAY then the possible states are:
                //challenge day completed
                //participated but did not complete (partial completion view opportunity)
                //and active day dot but no completion
                if ( i < [sortedChallengeDays count]) {
                    if ([allTheDates containsObject:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day]) {
                        if ([((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).completed boolValue]) {
                            //Make a dot for participated and did complete
                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                      andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                                          andNumber:dotNumber];
                            [dotsForDuration addObject:dot];

                        }
                        else {
                            //Make a dot for the state of "Participated but didn't complete"
                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                      andColorGroup:[DTDotColorGroup someParticipationAndStillActiveColorGroup]
                                                                          andNumber:dotNumber];
                            [dotsForDuration addObject:dot];
                        }
                    }
                    else{
                        //Make a dot for the active state of the day today
                        NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                        DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                  andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
                                                                      andNumber:dotNumber];
                        [dotsForDuration addObject:dot];
                    }
                }
            }

            //check dates in the past
            if ([cal ojf_compareDate:(NSDate*)[theSortedDurationDates objectAtIndex:i]
                              toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending) {
                NIDINFO(@"these are in the past: %@ today: %@",(NSDate*)[theSortedDurationDates objectAtIndex:i],today);
                //If there is a challenge day for the past then the possible states are:
                //failed
                //participated but did not complete (failed but with some effort)
                //just didn't participate at all -- complete and utter failure
                if ( i < [sortedChallengeDays count]) {
                    if ([allTheDates containsObject:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day]) {
                        if ([((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).completed boolValue]) {
                            //Make a dot for participated and did complete
                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                      andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                                          andNumber:dotNumber];
                            [dotsForDuration addObject:dot];
                        }
                        else {
                            //Make a dot for the state of "Participated but didn't complete"
                            NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                            DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                      andColorGroup:[DTDotColorGroup someParticipationButFailedColorGroup]
                                                                          andNumber:dotNumber];
                            [dotsForDuration addObject:dot];
                        }
                    }
                    else{
                        //Make a dot for failure state because you can't just up and change the past
                        NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                        DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                                  andColorGroup:[DTDotColorGroup failedDayColorGroup]
                                                                      andNumber:dotNumber];
                        [dotsForDuration addObject:dot];
                    }
                }
            }

            //check and handle all future dates
            if ([cal ojf_compareDate:(NSDate*)[theSortedDurationDates objectAtIndex:i]
                              toDate:today toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
                NIDINFO(@"these are in the future: %@ today: %@",(NSDate*)[theSortedDurationDates objectAtIndex:i],today);
                //The future is simple because it's just chock full of opportunity
                //make a dot for the state of "USER HAS NOT PARTICIPATED"
                NSNumber *dotNumber = [NSNumber numberWithInteger:[[cal components:NSDayCalendarUnit fromDate:((ChallengeDay*)[sortedChallengeDays objectAtIndex:i]).day] day]];
                DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 40., 40.)
                                                          andColorGroup:[DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup]
                                                              andNumber:dotNumber];
                [dotsForDuration addObject:dot];
            }
        }

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
