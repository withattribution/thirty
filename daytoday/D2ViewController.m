//
//  D2ViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2ViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface D2ViewController ()

@end

@implementation D2ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

#ifdef INTERFACE_DEMO_MODE
  SWRevealViewController *revealController = [self revealViewController];
  [self.navigationController.view addGestureRecognizer:revealController.panGestureRecognizer];
  [self.navigationController.navigationBar setHidden:YES];
#endif

}

- (CGFloat) padWithStatusBarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

-(UIColor*) randomColor
{
    return [UIColor randomColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext*) context
{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}

@end
