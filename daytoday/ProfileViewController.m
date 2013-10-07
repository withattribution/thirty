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
#import "Intent+D2D.h"
#import "User+D2D.h"
#import "AppDelegate.h"


@interface ProfileData : NSObject
@property(nonatomic,strong) User* selfUser;
@property(nonatomic,strong) NSArray* intents;
+(id) fakeProfileData;
-(NSManagedObjectContext*) context;
@end

@implementation ProfileData
@synthesize selfUser;
@synthesize intents;
+(id) fakeProfileData
{
    ProfileData *pf = [[ProfileData alloc] init];
    pf.selfUser = [User fakeSelfUser:pf.context];
    NSMutableArray *ma = [[NSMutableArray alloc] initWithCapacity:7];
    int n = ceil((arc4random()%6)) +2;
    for( int i = 0; i < n; i++){
        Intent *i = [Intent fakeIntent:pf.context];
        i.user = pf.selfUser;
        [ma addObject:i];
    }
    pf.intents = [NSArray arrayWithArray:ma];
    return pf;
}

-(NSManagedObjectContext*) context
{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
}
@end

@interface ProfileViewController ()
- (IBAction) searchChallenges:(id)sender;
- (IBAction) createChallenge:(id)sender;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NIDINFO(@"profile data: %d",[((ProfileData*)[ProfileData fakeProfileData]).intents count]);
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
