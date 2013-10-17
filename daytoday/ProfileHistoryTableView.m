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

#import "DTProgressElement.h"

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
        ProgressRowTableCell *cell = (ProgressRowTableCell *)[tableView dequeueReusableCellWithIdentifier:progressRowCellReuseIdentifier];
        if (cell == nil) {
            DTProgressElementLayout *dl = [[DTProgressElementLayout alloc] initWithIntent:[self.intents objectAtIndex:indexPath.section]];
            cell = [[ProgressRowTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:progressRowCellReuseIdentifier withDTProgressRows:[dl progressSnapShotElements]];
        }
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
    [sectHeaderView.sectionImageView setPathToNetworkImage: ((Image *)[((Intent *)[self.intents objectAtIndex:section]).challenge.image anyObject]).url
                                            forDisplaySize: CGSizeMake(320., 140.)
                                               contentMode: UIViewContentModeScaleAspectFill];
    return sectHeaderView;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
