//
//  AppDelegate.h
//  daytoday
//
//  Created by Alberto Tafoya on 12/04/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNavController.h"
#import "LoginRegistrationViewController.h"
#import "ProfileViewController.h"
#import "CreateChallengeViewController.h"
#import "ChallengeDetailVerificationController.h"

@class ViewController;
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) UIWindow *window;

@property (strong,nonatomic) DTNavController *navController;
@property (strong,nonatomic) LoginRegistrationViewController *loginController;
@property (strong,nonatomic) ProfileViewController *profileController;
@property (strong,nonatomic) ViewController *viewController;

#ifdef INTERFACE_DEMO_MODE
@property (strong,nonatomic) SWRevealViewController *demoController;
#endif

@end
