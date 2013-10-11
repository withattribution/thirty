//
//  ProfileHistoryTableView.m
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProfileHistoryTableView.h"
#import "ProfileTableCell.h"
#import "ProfileSectionHeaderView.h"
#import "Intent+D2D.h"
#import "Image+D2D.h"
#import "Challenge+D2D.h"

#import <UIColor+SR.h>

@implementation ProfileHistoryTableView
@synthesize intents;

static NSString *currentProgressCellReuseIdentifier = @"currentProgressCellIdentifier";
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
        
        [self registerClass:[ProfileTableCell class] forCellReuseIdentifier:currentProgressCellReuseIdentifier];
        [self registerClass:[ProfileSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderViewReuseIdentifier];
    }
    return self;
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NIDINFO(@"intent count %d", [self.intents count]);
    if (self.intents && [self.intents count] > 0) return [self.intents count];

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableCell *cell = (ProfileTableCell *)[tableView dequeueReusableCellWithIdentifier:currentProgressCellReuseIdentifier forIndexPath:indexPath];
//    NIDINFO(@"dequed cell: %@",cell);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProfileSectionHeaderView *sectHeaderView = (ProfileSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewReuseIdentifier];
    sectHeaderView.challengeLabel.text = [((Intent *)[self.intents objectAtIndex:section]).challenge name];
    [sectHeaderView.sectionImageView setPathToNetworkImage: ((Image *)[((Intent *)[self.intents objectAtIndex:section]).challenge.image anyObject]).url
                                            forDisplaySize: CGSizeMake(320., 140.)
                                               contentMode: UIViewContentModeScaleAspectFill];
    
//    [sectHeaderView.sectionImageView setPathToNetworkImage: @"http://daytoday-dev.s3.amazonaws.com/images/a0e2d3d7813b495181f56a7f528012a8.jpeg"
//                                            forDisplaySize: CGSizeMake(320., 140.)
//                                               contentMode: UIViewContentModeScaleAspectFill];
    
    return sectHeaderView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section != 0) {
    //        [self fadeAnim:cell];
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.viewDeckController.leftControllerIsClosed) {
//        if (indexPath.section != 0) {
//            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            self.selectedVenue = [self.currentVenues objectAtIndex:indexPath.row];
//            self.venueTable.scrollEnabled = NO;
//        }else {
//            [self presentFullScreenMapView:nil];
//        }
//    }
}

@end
