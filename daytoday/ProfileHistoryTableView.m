//
//  ProfileHistoryTableView.m
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProfileHistoryTableView.h"

@implementation ProfileHistoryTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsVerticalScrollIndicator:NO];
        [self setContentInset:UIEdgeInsetsZero];
    }
    return self;
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }else {
//        if (self.currentVenues && [self.currentVenues count] > 0) {
//            return [self.currentVenues count];
//        }else {
//            return 1;
//        }
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier   = @"parallaxTableViewCell";
    static NSString *windowReuseIdentifier = @"parallaxWindow";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
//        if ( !cell || [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:indexPath.row] == nil ) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
//            
//            VenueCellView *venueView = nil;
//            
//            if ([self.currentVenues count] > 0) {
//                venueView = [[VenueCellView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.venueTable.bounds.size.width, ROW_HEIGHT)
//                                                        andVenue:[self.currentVenues objectAtIndex:indexPath.row]];
//            }else {
//                venueView = [[VenueCellView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.venueTable.bounds.size.width, ROW_HEIGHT)];
//            }
//            
//            [venueView setTag:indexPath.row];
//            [cell addSubview:venueView];
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
        //self fadeAnim:cell];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return WINDOW_HEIGHT;
//    }else {
//        return ROW_HEIGHT;
//    }
    return 50.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section != 0) {
    //        [self fadeAnim:cell];
    //    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.viewDeckController.leftControllerIsClosed) {
//        if (indexPath.section != 0) {
//            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            self.selectedVenue = [self.currentVenues objectAtIndex:indexPath.row];
//            self.venueTable.scrollEnabled = NO;
//        }else {
//            [self presentFullScreenMapView:nil];
//        }
//    }
//}

@end
