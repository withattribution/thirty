//
//  AppDelegate.m
//  daytoday
//
//  Created by Alberto Tafoya on 12/04/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MurmurHash.h"

//soley for the demo interface mode
#ifdef INTERFACE_DEMO_MODE
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "DemoTableViewController.h"
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  NIMaxLogLevel = NILOGLEVEL_INFO;
  
  [Parse enableLocalDatastore];
  [Parse setApplicationId:@"pMydn1FlUYwUcXeLRRAMFp3zcZPz3lRQ6IITQEe2"
                clientKey:@"QJKFAJmMVCx69Nx7gWgK7s3ytyp7VgWrfhq1BCBk"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  #ifdef INTERFACE_DEMO_MODE
  FrontViewController *frontViewController = [[FrontViewController alloc] init];
  DemoTableViewController *rearViewController = [[DemoTableViewController alloc] init];
	
  UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
  UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
  self.demoController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController
                                                               frontViewController:frontNavigationController];
  self.window.rootViewController = self.demoController;
  #endif

  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
  if ([PFUser currentUser]) {
    if ([DTCommonUtilities minutesFromGMTForDate:[NSDate date]] != [[[PFUser currentUser] objectForKey:kDTUserGMTOffset] integerValue] ) {
      [[PFUser currentUser] setObject:@([DTCommonUtilities minutesFromGMTForDate:[NSDate date]]) forKey:kDTUserGMTOffset];
      [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded) {
          NIDINFO(@"updated GMT Offset: %@",[[PFUser currentUser] objectForKey:kDTUserGMTOffset]);
        }
        else {
          NIDINFO(@"user failed to update GMT Offset: %@",[error localizedDescription]);
        }
      }];
    }
  }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
