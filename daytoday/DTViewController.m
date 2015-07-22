//
//  DTViewController.m
//  daytoday
//
//  Created by Alberto Tafoya on 12/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "DTViewController.h"

@interface DTViewController ()

@end

@implementation DTViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
#ifdef INTERFACE_DEMO_MODE
  self.revealController = [self revealViewController];
  [self.navigationController.view addGestureRecognizer:self.revealController.panGestureRecognizer];
  [self.navigationController.navigationBar setHidden:YES];
#endif

}

- (CGFloat) padWithStatusBarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
