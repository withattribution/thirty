//
//  SearchChallengesViewController.m
//  daytoday
//
//  Created by Alberto Tafoya on 12/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "SearchChallengesViewController.h"


@interface SearchChallengesViewController ()

@end

@implementation SearchChallengesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = NSLocalizedString(@"Search Challenges", @"search challenges (title)");
  [[[DTCommonRequests logoutCurrentUser]
    continueWithExecutor:[BFExecutor mainThreadExecutor]
          withSuccessBlock:^id(BFTask *ts){
            UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logged Out"
                                                                message:@"you can't do much of anything now :("
                                                               delegate:nil
                                                      cancelButtonTitle:@"😭 😭 😭"
                                                      otherButtonTitles:nil];
            [logoutAlert show];
            return nil;
          }] continueWithBlock:^id(BFTask *task){
            //catch errors and return completed
            if (task.error)
              NIDINFO(@"error reporting: %@", [task.error localizedDescription]);
            return nil;
          }];
}


@end
