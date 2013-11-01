//
//  ChallengeDetailControllerViewController.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDetailViewController.h"
#import "DTVerificationElement.h"

#import "UIColor+SR.h"

@interface ChallengeDetailViewController ()

@end

@implementation ChallengeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  [self.view setBackgroundColor:[UIColor randomColor]];
  DTVerificationElement *el = [[DTVerificationElement alloc] initWithFrame:CGRectMake(150.f,150.f, 150.f, 150.f)];
  [el setBackgroundColor:[UIColor randomColor]];
  [self.view addSubview:el];
  [el drawVerificationSection];
  
  
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
