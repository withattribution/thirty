//
//  AppDelegate.m
//  daytoday
//
//  Created by Anderson Miller on 8/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import <NSManagedObject+SR.h>
#import <NSManagedObjectContext+SR.h>
#import "D2Request.h"

//soley for the demo interface mode
#ifdef INTERFACE_DEMO_MODE
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "DemoTableViewController.h"
#endif

@implementation AppDelegate

@synthesize navController;
@synthesize loginController,profileController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  NIMaxLogLevel = NILOGLEVEL_INFO;

  self.loginController = [[LoginRegistrationViewController alloc] init];
  self.profileController = [[ProfileViewController alloc] init];
  
  if(![[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifier])
      self.navController = [[D2NavController alloc] initWithRootViewController:self.loginController];
  else
      self.navController = [[D2NavController alloc] initWithRootViewController:self.profileController];
  self.window.rootViewController = self.navController;
  
  //check pch for definition
  #ifdef INTERFACE_DEMO_MODE
  FrontViewController *frontViewController = [[FrontViewController alloc] init];
	DemoTableViewController *rearViewController = [[DemoTableViewController alloc] init];
	
	UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
  UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
	
  self.demoController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
  
  self.window.rootViewController = self.demoController;
  #endif

  [self.window makeKeyAndVisible];

  // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
  // or set runtime properties here.
//  UAConfig *config = [UAConfig defaultConfig];
  
  // You can also programmatically override the plist values:
  // config.developmentAppKey = @"YourKey";
  // etc.
  
  // Call takeOff (which creates the UAirship singleton)
//  [UAirship takeOff:config];
  return YES;
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//  NIDINFO(@"APN device token: %@", deviceToken);
//
//  NSString *k = @"kUADeviceToken";
//  if( [[NSUserDefaults standardUserDefaults] valueForKey:k] == nil ){
//      NSString * dToken = [NSString stringWithFormat:@"%@",deviceToken];
//      [[NSUserDefaults standardUserDefaults] setValue:dToken forKey:k];
//      [[NSUserDefaults standardUserDefaults] synchronize];
//  }
//  
//  // Updates the device token and registers the token with UA
//  
//  [[UAPush shared] registerDeviceToken:deviceToken];
//}

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

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NIDERROR(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DayTodayModels" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DayTodayModels.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
                     130          Replace this implementation with code to handle the error appropriately.
                     131
                     132          abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     133
                     134          Typical reasons for an error here include:
                     135          * The persistent store is not accessible;
                     136          * The schema for the persistent store is incompatible with current managed object model.
                     137          Check the error message to determine what the actual problem was.
                     138
                     139
                     140          If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
                     141
                     142          If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                     143          * Simply deleting the existing store:
                     144          [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
                     145
                     146          * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                     147          @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
                     148
                     149          Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
                     150          
                     151          */
        NIDERROR(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

 // Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
