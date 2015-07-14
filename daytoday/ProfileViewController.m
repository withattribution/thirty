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

- (id)initWithUser:(PFUser *)user
{
  self = [super init];
  if (self) {
    self.aUser = user;
  }
  return self;
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

  [[DTCommonRequests retrieveIntentsForUser:self.aUser] continueWithBlock:^id(BFTask *ts){
    if ([ts.result count] > 0) {
      self.historyTable = [[ProfileHistoryTableView alloc] initWithFrame:CGRectMake(0,
                                                                                    profileHeightOffset,
                                                                                    self.view.frame.size.width,
                                                                                    self.view.frame.size.height - profileHeightOffset)];
      [self.view addSubview:self.historyTable];
      [self.historyTable setIntentsArray:ts.result];
      [self.historyTable reloadData];
    }else {
      UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    profileHeightOffset,
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.height - profileHeightOffset)];
      [yellowView setBackgroundColor:[UIColor blueColor]];
      [self.view addSubview:yellowView];
    }
    return nil;
  }];
}

@end
