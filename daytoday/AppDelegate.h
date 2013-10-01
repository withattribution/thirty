//
//  AppDelegate.h
//  daytoday
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D2NavController.h"
#import "LoginRegistrationViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) D2NavController *navController;

@property (strong,nonatomic) LoginRegistrationViewController *loginController;

@property (strong, nonatomic) ViewController *viewController;

@end
