//
//  DemoTableViewController.m
//  daytoday
//
//  Created by pasmo on 11/5/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DemoTableViewController.h"
#import "SWRevealViewController.h"

#import "LoginRegistrationViewController.h"
#import "ProfileViewController.h"
#import "CreateChallengeViewController.h"
#import "ChallengeDetailContainer.h"
#import "SearchChallengesViewController.h"

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController {
  NSArray *_names;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.navigationController.navigationBar setHidden:YES];
  [self.view setBackgroundColor:[UIColor lightGrayColor]];
  
  _names = [NSArray arrayWithObjects:@"LOGIN / REGISTRATION",@"PROFILE",@"CHALLENGE CREATION",@"CHALLENGE DAY DETAIL",@"SEARCH CHALLENGE", nil];
  
  UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.view.frame.size.width, 60.)];
  h.backgroundColor = [UIColor lightGrayColor];
  self.tableView.tableHeaderView = h;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_names count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[_names objectAtIndex:indexPath.row]]];
    return cell;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  SWRevealViewController *revealController = self.revealViewController;
  
  UINavigationController *frontNavigationController = (id)revealController.frontViewController;
  
  switch (indexPath.row) {
    case 0:
      if ( ![frontNavigationController.topViewController isKindOfClass:[LoginRegistrationViewController class]] )
      {
        LoginRegistrationViewController *loginVC = [[LoginRegistrationViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [revealController setFrontViewController:navigationController animated:YES];
      }
      else
      {
        [revealController revealToggle:self];
      }
      break;
    case 1:
      if ( ![frontNavigationController.topViewController isKindOfClass:[ProfileViewController class]] )
      {
        ProfileViewController *loginVC = [[ProfileViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [revealController setFrontViewController:navigationController animated:YES];
      }
      else
      {
        [revealController revealToggle:self];
      }
      break;
    case 2:
      if ( ![frontNavigationController.topViewController isKindOfClass:[CreateChallengeViewController class]] )
      {
        CreateChallengeViewController *loginVC = [[CreateChallengeViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [revealController setFrontViewController:navigationController animated:YES];
      }
      else
      {
        [revealController revealToggle:self];
      }
      break;
    case 3:
      if ( ![frontNavigationController.topViewController isKindOfClass:[ChallengeDetailContainer class]] )
      {
        ChallengeDetailContainer *loginVC = [[ChallengeDetailContainer alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [revealController setFrontViewController:navigationController animated:YES];
      }
      else
      {
        [revealController revealToggle:self];
      }
      break;
    case 4:
      if ( ![frontNavigationController.topViewController isKindOfClass:[SearchChallengesViewController class]] )
      {
        SearchChallengesViewController *loginVC = [[SearchChallengesViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [revealController setFrontViewController:navigationController animated:YES];
      }
      else
      {
        [revealController revealToggle:self];
      }
      break;
    default:
      break;
  }
}

@end
