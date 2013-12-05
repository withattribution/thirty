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
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  NIMaxLogLevel = NILOGLEVEL_INFO;

//  self.loginController = [[LoginRegistrationViewController alloc] init];
//  self.profileController = [[ProfileViewController alloc] init];
  
//  if(![[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifier])
//      self.navController = [[DTNavController alloc] initWithRootViewController:self.loginController];
//  else
//      self.navController = [[DTNavController alloc] initWithRootViewController:self.profileController];
//  self.window.rootViewController = self.navController;
  
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
  
  [Parse setApplicationId:@"pMydn1FlUYwUcXeLRRAMFp3zcZPz3lRQ6IITQEe2"
                clientKey:@"QJKFAJmMVCx69Nx7gWgK7s3ytyp7VgWrfhq1BCBk"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//  [PFUser logOut];
//  [self createTestModels];

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

- (void)createTestModels
{
  PFObject *challenge = [PFObject objectWithClassName:kDTChallengeClassKey];
  [challenge setObject:@"Do yoga for 30 days" forKey:kDTChallengeDescriptionKey];
  [challenge setObject:@(30) forKey:kDTChallengeDurationKey];
  [challenge setObject:@(1) forKey:kDTChallengeFrequencyKey];
  [challenge setObject:@"fitness" forKey:kDTChallengeCategoryKey];
  [challenge setObject:@"YTTP Challenge" forKey:kDTChallengeNameKey];

//  [challenge setObject:@"Do yoga for 30 days" forKey:kDTChallengeImageKey];

  [challenge setObject:[PFUser currentUser] forKey:kDTChallengeCreatedByKey];
  [challenge setObject:kDTChallengeVerificationTypeTick forKey:kDTChallengeVerificationTypeKey];

  [challenge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
    if(succeeded){
      NIDINFO(@"saved an example challenge!");
//      if([[NSUserDefaults standardUserDefaults] valueForKey:kDTChallengeUserSeed] == nil ){
      MurmurHash *hash = [[MurmurHash alloc] init];
      uint32_t userSeed = [hash hash32:[[PFUser currentUser] objectId]];
//      NIDINFO(@"user seed: %u",userSeed);
//      NIDINFO(@"challenge id: %@",[challenge objectId]);

      uint32_t challengeUserHash = [hash hash32:[challenge objectId]  withSeed:userSeed];
//      NIDINFO(@"challenge user seed: %u",challengeUserHash);
      
      NSNumber *challengeUserSeed = [NSNumber numberWithUnsignedInt:challengeUserHash];
//      NIDINFO(@"challenge user seed number-int: %u",[challengeUserSeed unsignedIntValue]);

      [[NSUserDefaults standardUserDefaults] setValue:challengeUserSeed forKey:kDTChallengeUserSeed];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
//      NIDINFO(@"challenge user seed number-int: %u",[challengeUserSeed unsignedIntValue]);
//      }
    }
    else {
//      NIDINFO(@"%@",[err localizedDescription]);
    }
  }];
}

//One time only make a challenge day object so that we can reuse the challenge day object id to build out the comment interface
//      PFObject *intent = [PFObject objectWithClassName:kDTIntentClassKey];
//      [intent setObject:[NSDate dateWithTimeInterval:(60.*60.*24*14*-1) sinceDate:[NSDate date]] forKey:kDTIntentStartingKey];
//      [intent setObject:[NSDate dateWithTimeInterval:(60.*60.*24*14*1) sinceDate:[NSDate date]] forKey:kDTIntentEndingKey];
//      [intent setObject:[PFUser currentUser] forKey:kDTIntentUserKey];
//      [intent setObject:[challenge objectId] forKey:kDTIntentChallengeKey];
//
//      [intent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//        if(succeeded){
//          NIDINFO(@"saved an example intent!");
//
//        }
//        else {
//          NIDINFO(@"%@",[err localizedDescription]);
//        }
//      }];


//      PFObject *challengeDay = [PFObject objectWithClassName:kDTChallengeDayClassKey];
//      challengeDay[kDTChallengeDayTaskRequiredCountKey] = @3;
//      challengeDay[kDTChallengeDayTaskCompletedCountKey] = @1;
//      challengeDay[kDTChallengeDayOrdinalDayKey] = @14;
//      challengeDay[kDTChallengeDayAccomplishedKey] = @NO;
//      challengeDay[kDTChallengeDayActiveDateKey] = [NSDate date];
//      challengeDay[kDTChallengeDayIntentKey] = [PFObject objectWithoutDataWithClassName:kDTIntentClassKey objectId:intent.objectId];
//
//      [challengeDay saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//        if (succeeded){
//          NIDINFO(@"succeeded!");
//        }else {
//          NIDINFO(@"%@",[err localizedDescription]);
//        }
//      }];

//when we used to generate the active date key on the client
//+ (PFQuery *)queryForchallengeDayForDate:(NSDate *)date
//{
//  NSDateFormatter *df = [[NSDateFormatter alloc] init];
//  [df setDateFormat:@"MM/dd/yyyy"];
//  //  NSString *formattedDate = [df stringFromDate:date];
//  //
//  //  NIDINFO(@"date %@",formattedDate);
//  NSString *formattedDate = @"12/02/2013";
//  
//  
//  uint32_t challengeUserSeed = [[[NSUserDefaults standardUserDefaults] objectForKey:kDTChallengeUserSeed] unsignedIntValue];
//  
//  MurmurHash *hash = [[MurmurHash alloc] init];
//  uint32_t challengeDayHash = [hash hash32:formattedDate withSeed:challengeUserSeed];
//  
//  NIDINFO(@"hash %u",challengeDayHash);
//  PFQuery *dayQuery = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
//  [dayQuery whereKey:kDTChallengeDayActiveDateKey equalTo:@(challengeDayHash)];
//  [dayQuery includeKey:kDTChallengeDayIntentKey];
//  dayQuery.cachePolicy = kPFCachePolicyNetworkOnly;
//  
//  return dayQuery;
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

@end
