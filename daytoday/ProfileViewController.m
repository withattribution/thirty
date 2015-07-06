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

- (BOOL)hasCachedIntents;

@end

@implementation ProfileViewController

- (id)initWithUser:(PFUser *)user
{
  self = [super init];
  if (self) {
    self.aUser = user;
  }
  return self;
}

- (BOOL)hasCachedIntents
{
  return [[DTCache sharedCache] intentsForUser:self.aUser] != nil;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
  
  UserInfoHeader *infoHeader = [[UserInfoHeader alloc] initWithFrame:CGRectMake(0.f
                                                                                ,[self padWithStatusBarHeight]
                                                                                ,self.view.frame.size.width
                                                                                ,105.f)
                                                            withUser:self.aUser];
  [self.view addSubview:infoHeader];
  
  NIDINFO(@"user who will have profile view: %@",self.aUser);
  
  CGFloat profileHeightOffset = infoHeader.frame.origin.y + infoHeader.frame.size.height;
  self.historyTable = [[ProfileHistoryTableView alloc] initWithFrame:CGRectMake(0,
                                                                                profileHeightOffset,
                                                                                self.view.frame.size.width,
                                                                                self.view.frame.size.height - profileHeightOffset)];
  [self.view addSubview:self.historyTable];

  if (![self hasCachedIntents]) {
    [DTCommonRequests retrieveIntentsForUser:self.aUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cachedIntentsForUser:)
                                                 name:DTIntentDidCacheIntentsForUserNotification
                                               object:nil];
  }
  else{
    [self.historyTable setIntentsArray:[[DTCache sharedCache] intentsForUser:self.aUser]];
    [self.historyTable reloadData];
  }
  NSArray *intents = [[DTCache sharedCache] intentsForUser:self.aUser];
  for (PFObject *i in intents) {
    NIDINFO(@"the intents: %@",i);
  }
}

#pragma mark - Intents for User Cache Refreshed Notification

- (void)cachedIntentsForUser:(NSNotification *)aNotification
{
  if (aNotification.object && [aNotification.object count] > 0) {
    NIDINFO(@"the object: %@",aNotification.object);
    [self.historyTable setIntentsArray:aNotification.object];
    [self.historyTable reloadData];
  }else {
    NIDINFO(@"error refreshing challenge days cache for intent");
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTIntentDidCacheIntentsForUserNotification
                                                object:nil];
}
@end
