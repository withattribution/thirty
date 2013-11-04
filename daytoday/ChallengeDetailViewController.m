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
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  self.eldt = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,50.f, 200.f, 200.f)];
  [self.eldt setCenter:CGPointMake(self.view.center.x,self.eldt.center.y)];
  
  [self.eldt setDataSource:self];
  [self.eldt setDelegate:self];
  
  [self.eldt setAnimationSpeed:1.0];
  [self.view addSubview:self.eldt];
}

-(void)verificationElement:(DTVerificationElement *)element didVerifySection:(NSUInteger)section
{
  NSLog(@"element: %@ and section:%d",element,section);
}

- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element
{
  return 0; //numberCompleted
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  return 3; //numberRequired
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.eldt reloadData:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
