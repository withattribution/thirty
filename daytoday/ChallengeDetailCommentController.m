//
//  ChallengeDetailCommentController.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDetailCommentController.h"
#import "DTSocialDashBoard.h"
#import "ChallengeDayCommentTableView.h"

@interface ChallengeDetailCommentController ()

@end

@implementation ChallengeDetailCommentController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor lightGrayColor]];
  
  DTSocialDashBoard *social = [[DTSocialDashBoard alloc] init];
  [social setFrame:CGRectMake(0.f, 0.f, 320.f, 60.f)];
  [self.view addSubview:social];
  
  ChallengeDayCommentTableView *comments = [[ChallengeDayCommentTableView alloc]
                                            initWithFrame:CGRectMake(0.,
                                                                     social.frame.origin.y + social.frame.size.height,
                                                                     320.f,
                                                                     480.f - 60.f)];
  [self.view addSubview:comments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
