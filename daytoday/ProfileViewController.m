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
      NSArray *theIntentsArray = [NSArray arrayWithObjects:[intents firstObject], nil];
      [self.historyTable setIntentsArray:theIntentsArray];
      [self.historyTable reloadData];
    }else {
      NIDINFO(@"error: %@ and count: %d",[error localizedDescription], [intents count]);
    }
  }];
}


//#pragma mark - DTChallengeDaysRetrieved Notification
//
//- (void)didRetrieveDaysForIntent:(NSNotification *)aNotification
//{
//  if (aNotification.object) {
////    self.challengeDay = (PFObject *)aNotification.object;
////    [self addChallengeDayInterface];
//    
//  }else {
//    NIDINFO(@"nil challenge day deal with it!");
//  }
//}
@end
