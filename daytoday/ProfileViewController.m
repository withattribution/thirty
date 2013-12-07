//
//  ProfileViewController.m
//  daytoday
//
//  Created by Alberto Tafoya on 12/2/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ProfileViewController.h"

#import "UserInfoHeader.h"
#import "ProfileHistoryTableView.h"

#import "DTProgressElement.h"


@interface ProfileViewController ()

@property (nonatomic,strong) ProfileHistoryTableView *historyTable;
@property (nonatomic,strong) NSArray *intentsArray;
@end

@implementation ProfileViewController

- (id)init
{
  self = [super init];
  if (self) {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didRetrieveDaysForIntent:)
//                                                 name:DTChallengeDaysForIntentRetrievedNotification
//                                               object:nil];
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
                                                            withUser:[PFUser currentUser]];
  [self.view addSubview:infoHeader];

  NIDINFO(@"current user: %@",[[PFUser currentUser] objectId]);
  
  CGFloat profileHeightOffset = infoHeader.frame.origin.y + infoHeader.frame.size.height;
  self.historyTable = [[ProfileHistoryTableView alloc] initWithFrame:CGRectMake(0,
                                                                                profileHeightOffset,
                                                                                self.view.frame.size.width,
                                                                                self.view.frame.size.height - profileHeightOffset)];
  [self.view addSubview:self.historyTable];
  [self intentsForUser:[PFUser currentUser]];
}

- (void)intentsForUser:(PFUser *)user
{
  PFQuery *intentQuery = [PFQuery queryWithClassName:kDTIntentClassKey];
  [intentQuery whereKey:kDTIntentUserKey equalTo:user];
  [intentQuery findObjectsInBackgroundWithBlock:^(NSArray *intents, NSError *error){
    if (!error && [intents count] > 0) {
      
      self.intentsArray = [NSArray arrayWithObjects:[intents firstObject], nil];
      NSArray *challengeDays = [[DTCache sharedCache] challengeDaysForIntent:[intents firstObject]];
      
      if (!challengeDays || [challengeDays count] == 0) {
        //try to refresh from the network
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didCacheDaysForIntent:)
                                                     name:DTChallengeDayDidCacheDaysForIntentNotification
                                                   object:nil];

        [DTCommonRequests requestDaysForIntent:[intents firstObject] cachePolicy:kPFCachePolicyNetworkOnly];
      }
    }else {
      NIDINFO(@"error: %@ and count: %d",[error localizedDescription], [intents count]);
    }
  }];
}

#pragma mark - DTChallengeDays Cache Refreshed Notification

- (void)didCacheDaysForIntent:(NSNotification *)aNotification
{
  if (aNotification.object && [aNotification.object count] > 0) {
    [self.historyTable setIntentsArray:self.intentsArray];
    [self.historyTable reloadData];
  }else {
    NIDINFO(@"error refreshing challenge days cache for intent");
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTChallengeDayDidCacheDaysForIntentNotification
                                                object:nil];
}
@end
