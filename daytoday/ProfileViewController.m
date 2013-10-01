//
//  ProfileViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIColor+SR.h>
#import "SearchChallengesViewController.h"
#import "CreateChallengeViewController.h"
@interface ProfileViewController ()
- (IBAction) searchChallenges:(id)sender;
- (IBAction) createChallenge:(id)sender;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchChallengesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        createChallengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchChallengesButton.frame = CGRectMake(10, 100, 300, 100);
        createChallengeButton.frame = CGRectMake(10, 210, 300, 100);
        [searchChallengesButton setTitle:NSLocalizedString(@"Search Challenges", @"search challenges (button)") forState:UIControlStateNormal];
        [createChallengeButton setTitle:NSLocalizedString(@"Create Challenges", @"create challenges (button)") forState:UIControlStateNormal];
        
        searchChallengesButton.backgroundColor = [UIColor randomColor];
        createChallengeButton.backgroundColor = [UIColor randomColor];
        [searchChallengesButton addTarget:self action:@selector(searchChallenges:) forControlEvents:UIControlEventTouchUpInside];
        [createChallengeButton addTarget:self action:@selector(createChallenge:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchChallengesButton];
        [self.view addSubview:createChallengeButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Profile View", @"profile view");
	// Do any additional setup after loading the view.
}

- (IBAction) searchChallenges:(id)sender
{
    SearchChallengesViewController *scvc = [[SearchChallengesViewController alloc] init];
    [self.navigationController pushViewController:scvc animated:YES];
}
- (IBAction) createChallenge:(id)sender
{
    CreateChallengeViewController *ccvc = [[CreateChallengeViewController alloc] init];
    [self.navigationController pushViewController:ccvc animated:YES];
}


@end
