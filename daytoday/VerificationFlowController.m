//
//  VerificationFlowController.m
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "VerificationFlowController.h"
#import "VerificationStatusTable.h"

@interface VerificationFlowController () <VerificationStatusTableDelegate>

@property (nonatomic,strong) VerificationStatusTable *statusTable;

@end

@implementation VerificationFlowController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //handle the selection of an image here
  
  //since this is a first pass for the tick mark verification type -- skip directly to the status input screen
  self.statusTable = [[VerificationStatusTable alloc] initWithFrame:self.view.frame];
  //set the image or set the mkmapview to be uploaded or set the time to be uploaded here as well
  [self.statusTable setCancelDelegate:self]; // this is just a callback delegate for the cancel button (not a uitableview delegate)
  [self.statusTable setChallenge:[[DTCache sharedCache] challengeForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]]];
  [self.statusTable setChallengeDay:[[DTCache sharedCache] challengeDayForDate:[NSDate date] intent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]]];

  [self.view addSubview:self.statusTable];
  [self presentStatusUpdateTableView];
  
}

- (void)presentStatusUpdateTableView
{
  CGRect originFrame = CGRectMake(0.f, -1*self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
  CGRect finalFrame  = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
  
  [self.statusTable setFrame:originFrame];
  
  [UIView animateWithDuration:0.42f
                   animations:^{
                     [self.view setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:0.9f]];
                     [self.statusTable setFrame:finalFrame];
                   }
                   completion:^(BOOL finished) {
                     
                   }];
}


- (void)dismissStatusUpdateTableView
{
  CGRect finalFrame = CGRectMake(0.f, -1*self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);

  [UIView animateWithDuration:0.42f
                   animations:^{
                     [self.view setBackgroundColor:[UIColor clearColor]];
                     [self.statusTable setFrame:finalFrame];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                     [self.parentViewController willMoveToParentViewController:self];
//                     [self.parentViewController viewWillAppear:NO];
                     [self removeFromParentViewController];
                   }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - VerificationStatusTable Delegate Method

- (void)didTapCancelButton:(UIButton *)aButton
{
  [self dismissStatusUpdateTableView];
  //zoom -- the table view disappears below the fold!
}

@end
