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
#import "ProfileViewController.h"
#import "CreateChallengeViewController.h"
#import "ChallengeDetailViewController.h"
#import <CoreData/CoreData.h>

@class ViewController;
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) UIWindow *window;

@property (strong,nonatomic) D2NavController *navController;
@property (strong,nonatomic) LoginRegistrationViewController *loginController;
@property (strong,nonatomic) ProfileViewController *profileController;
@property (strong,nonatomic) ViewController *viewController;

#ifdef INTERFACE_DEMO_MODE
@property (strong,nonatomic) SWRevealViewController *demoController;
#endif

@property (readonly,strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly,strong,nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly,strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
