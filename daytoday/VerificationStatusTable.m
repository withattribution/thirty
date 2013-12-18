//
//  VerificationStatusTable.m
//  daytoday
//
//  Created by pasmo on 12/17/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Verification.h"
#import "VerificationStatusTable.h"
#import "VerificationStatusInputCell.h"

@interface VerificationStatusTable () <UITableViewDelegate, UITableViewDataSource, VerificationStatusCellDelegate>

@end

@implementation VerificationStatusTable

#define kStatusRowInset 5.f

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
      
      self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 55.f)];
      [self.tableHeaderView setBackgroundColor:[UIColor colorWithWhite:0.25f alpha:.95f]];
      
      UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [cancelButton setFrame:CGRectMake(0.f, 20.f, self.frame.size.width / 4.f, 35.f)];
      [cancelButton setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.f]];
      [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
      [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
      [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
      [cancelButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
      [cancelButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
      [self.tableHeaderView addSubview:cancelButton];
    }
    return self;
}

#pragma mark UITableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [VerificationStatusInputCell hasImage:(self.imageViewToUpload != nil || self.mapToUpload != nil)
                                cellInsetWidth:kStatusRowInset];
}

#pragma mark UITableView DataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellID = @"statusInputCell";
  
  VerificationStatusInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[VerificationStatusInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.cellInsetWidth = kStatusRowInset;
    cell.delegate = self;
  }
  [cell setUser:[PFUser currentUser]];
  [cell setOrdinal:[NSNumber numberWithInt:[[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] + 1]];
  [cell setVerificationType:(DTVerificationType)[self.challenge objectForKey:kDTChallengeVerificationTypeKey]];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

#pragma mark VerificationStatusCell Delegate Method

- (void)cell:(VerificationStatusInputCell *)cellView didTapSubmitButton:(UITextView *)textView
{
  [DTCommonRequests verificationActivity:textView.text];
}

#pragma mark VerificationStatusTable Dismiss TableView Delegate Method

- (void)userPressedCancelButton:(UIButton *)aButton
{
  if ([_cancelDelegate respondsToSelector:@selector(didTapCancelButton:)]) {
    [_cancelDelegate didTapCancelButton:aButton];
  }
}

@end
