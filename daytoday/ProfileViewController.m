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
#import "Challenge+D2D.h"
#import "AppDelegate.h"
#import "Image+D2D.h"
#import "UserInfoHeader.h"
#import "ProfileHistoryTableView.h"

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
    NSString* img1small = @"http://daytoday-dev.s3.amazonaws.com/images/2c32de43c82d4bdf9cccf3af21f806ba.jpg";
    NSString* img1med = @"http://daytoday-dev.s3.amazonaws.com/images/b0a01ab4d03f4357b615a87ffec289ff.jpg";
    NSString* img1large = @"http://daytoday-dev.s3.amazonaws.com/images/f2b0f86ebf5b4919b5d802cfdebb3ec6.jpg";
    NSString *img2small = @"http://daytoday-dev.s3.amazonaws.com/images/369db3f333dd48c181f9aec5abd5613e.jpg";
    NSString *img2med  = @"http://daytoday-dev.s3.amazonaws.com/images/11517c77f110459ba2e2fa7ef473cbcb.jpg";
    NSString *img2large = @"http://daytoday-dev.s3.amazonaws.com/images/5f9d500d33e243e4acca433649f26aa7.jpg";

    ProfileData *pf = [[ProfileData alloc] init];
    Image *i1 = [Image imageWithURL:img1med andContext:pf.context];
    i1.tag = kImageMediumTag;
    Image *i2 = [Image imageWithURL:img1small andContext:pf.context];
    i2.tag = kImageSmallTag;
    Image *i3 = [Image imageWithURL:img1large andContext:pf.context];
    i3.tag = kImageLargeTag;
    NSSet *imgs = [NSSet setWithObjects:i1,i2,i3,nil];
    pf.selfUser = [User fakeSelfUser:pf.context];
    [pf.selfUser addImage:imgs];
    [i1 setUser:pf.selfUser];

    NSMutableArray *ma = [[NSMutableArray alloc] initWithCapacity:7];
    int n = ceil((arc4random()%6)) +2;
    for( int i = 0; i < n; i++){
        Intent *i = [Intent fakeIntent:pf.context];
        i.user = pf.selfUser;
        Image *i3 = [Image imageWithURL:img2med andContext:pf.context];
        i3.tag = kImageMediumTag;
        Image *i1 = [Image imageWithURL:img2small andContext:pf.context];
        i1.tag = kImageSmallTag;
        Image *i2 = [Image imageWithURL:img2large andContext:pf.context];
        i2.tag = kImageLargeTag;
        Challenge *c1 = i.challenge;
        
        [c1 addImage:[NSSet setWithObjects:i1,i2,i3,nil]];
        [i3 setChallenge:c1];
        
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
//        NIDINFO(@"profile data: %d",[((ProfileData*)[ProfileData fakeProfileData]).intents count]);
        // Custom initialization
//        searchChallengesButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        createChallengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchChallengesButton.frame = CGRectMake(10, 100, 300, 100);
//        createChallengeButton.frame = CGRectMake(10, 210, 300, 100);
//        [searchChallengesButton setTitle:NSLocalizedString(@"Search Challenges", @"search challenges (button)") forState:UIControlStateNormal];
//        [createChallengeButton setTitle:NSLocalizedString(@"Create Challenges", @"create challenges (button)") forState:UIControlStateNormal];
//        
//        searchChallengesButton.backgroundColor = [UIColor randomColor];
//        createChallengeButton.backgroundColor = [UIColor randomColor];
//        [searchChallengesButton addTarget:self action:@selector(searchChallenges:) forControlEvents:UIControlEventTouchUpInside];
//        [createChallengeButton addTarget:self action:@selector(createChallenge:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:searchChallengesButton];
//        [self.view addSubview:createChallengeButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.];
    UserInfoHeader *infoHeader = [[UserInfoHeader alloc] initWithFrame:CGRectMake(0.f,
                                                                                  [self padWithStatusBarHeight],
                                                                                  self.view.frame.size.width,
                                                                                  105.f)
                                  withUser:((ProfileData*)[ProfileData fakeProfileData]).selfUser];
    [self.view addSubview:infoHeader];

    CGFloat profileHeightOffset = infoHeader.frame.origin.y + infoHeader.frame.size.height;
    ProfileHistoryTableView *historyTable = [[ProfileHistoryTableView alloc] initWithFrame:CGRectMake(0,
                                                                                                      profileHeightOffset,
                                                                                                      self.view.frame.size.width,
                                                                                                      self.view.frame.size.height - profileHeightOffset)];
    [historyTable setIntents:((ProfileData*)[ProfileData fakeProfileData]).intents];
    [self.view addSubview:historyTable];
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
