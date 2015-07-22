//
//  ProfileHistoryTableView.m
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ProfileHistoryTableView.h"
#import "ProfileSectionHeaderView.h"

#import "DaysLeftTableCell.h"
#import "ProgressSnapShotTableCell.h"
#import "ParticipantsTableCell.h"
#import "ProgressSummaryCell.h"

#import "DTChallengeCalendar.h"

#import "DTProgressElement.h"

@interface ProfileHistoryTableView ()

@end

@implementation ProfileHistoryTableView

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
        
        //register the header view so that we can "fancy deque it"
        [self registerClass:[ProfileSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderViewReuseIdentifier];
    }
    return self;
}

#pragma mark - Table View Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ProgressSnapShotTableCell *cell = (ProgressSnapShotTableCell *)[tableView
                                                                  dequeueReusableCellWithIdentifier:progressRowCellReuseIdentifier];
  if (cell == nil) {
    cell = [[ProgressSnapShotTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:progressRowCellReuseIdentifier
                                         withIntent:[self.intentsArray objectAtIndex:indexPath.row]];
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.intents && [self.intents count] > 0)
//        return [self.intents count];
//    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.intentsArray count];
//    if([([self.intents objectAtIndex:section]) daysLeft] > 0)
//        return 3;
//    else
//        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([((Intent *)[self.intents objectAtIndex:indexPath.section]) daysLeft] > 0){
//        if (indexPath.row == 1)
//            return 87.f;
//        if (indexPath.row == 2)
//            return 45.f;
//        else
//            return 40.f;
//    }
//    else
  return 140;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 110.f;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ProfileSectionHeaderView *sectHeaderView = (ProfileSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewReuseIdentifier];
//    sectHeaderView.challengeLabel.text = [((Intent *)[self.intents objectAtIndex:section]).challenge name];
//    [sectHeaderView.sectionImageView setPathToNetworkImage: ((Image *)[((Intent *)[self.intents objectAtIndex:section]).challenge.image anyObject]).url
//                                            forDisplaySize: CGSizeMake(320., 140.)
//                                               contentMode: UIViewContentModeScaleAspectFill];
//    return sectHeaderView;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
