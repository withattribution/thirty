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
  
  self.eldt = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,50.f, 150.f, 150.f)];
  [self.eldt setDataSource:self];
  [self.eldt setAnimationSpeed:5.0];
  [self.view addSubview:self.eldt];
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  return 4;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.eldt reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
