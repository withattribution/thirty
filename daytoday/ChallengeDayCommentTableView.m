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

@property (nonatomic,strong) NSArray *rowData;
@property (nonatomic,strong) NSArray *sectionData;

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
      
      //fake data because well that's what we have for now
      self.rowData = [NSArray arrayWithObjects:@"1",@"2",@"3",nil];
      self.sectionData = [NSArray arrayWithObjects:@"1",@"2",nil];
    }
    return self;
}

- (void)scrollToLastComment
{
  NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:[self.rowData indexOfObject:[self.rowData lastObject]]
                                                    inSection:[self.sectionData indexOfObject:[self.sectionData lastObject]]];
  
  [self scrollToRowAtIndexPath:bottomIndexPath
              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
  return [self.sectionData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.rowData count];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

@end
