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
    NSString* img1small = @"http://daytoday-dev.s3.amazonaws.com/images/a0e2d3d7813b495181f56a7f528012a8.jpg";
    NSString* img1med = @"http://daytoday-dev.s3.amazonaws.com/images/8debb5be40f448f4a6583a8de67b731b.jpg";
    NSString* img1large = @"http://daytoday-dev.s3.amazonaws.com/images/9720b86c720d4fb7a05d4b8cac8346a5.jpg";
    NSString *img2small = @"http://daytoday-dev.s3.amazonaws.com/images/6fdd5ad843b94bcf9b147328072e02a3.jpg";
    NSString *img2med  = @"http://daytoday-dev.s3.amazonaws.com/images/1433910dd3b9443fb3d3fb2151866114.jpg";
    NSString *img2large = @"http://daytoday-dev.s3.amazonaws.com/images/a9fc822504d947318c8c0adf99f4b116.jpg";

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
    // self.title = NSLocalizedString(@"Profile View", @"profile view");

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
    [self.view addSubview:historyTable];
//    User *selfUser = ((ProfileData*)[ProfileData fakeProfileData]).selfUser;
//    NIDINFO(@"profile data: %@",((ProfileData*)[ProfileData fakeProfileData]).selfUser);
//    NIDINFO(@"the fake info %@",[ProfileData fakeProfileData]);

//     these are intents!
//    @property (nonatomic, retain) NSDate * ending;
//    @property (nonatomic, retain) NSNumber * intentId;
//    @property (nonatomic, retain) NSDate * starting;
//    @property (nonatomic, retain) Challenge *challenge;
//    @property (nonatomic, retain) NSSet *days;
//    @property (nonatomic, retain) User *user;
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
