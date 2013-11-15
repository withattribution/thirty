//
//  ChallengeDayCommentTableView.m
//  daytoday
//
//  Created by pasmo on 11/11/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//


#import "UIColor+SR.h"
#import "ChallengeDayCommentTableView.h"

@interface ChallengeDayCommentTableView ()

@end


@implementation ChallengeDayCommentTableView

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
      
//      UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 320., 50.)];
//      [tableHeader setBackgroundColor:[UIColor redColor]];
//      self.tableHeaderView = tableHeader;
      
    }
    return self;
}

#pragma mark - Table View Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [[UITableViewCell alloc] init];
  cell.backgroundColor = [UIColor randomColor];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

@end
