//
//  ChallengeDetailControllerViewController.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDetailVerificationController.h"
#import "DTVerificationElement.h"

#import "ChallengeDayCommentTableView.h"
#import "ChallengeDayDetail.h"

#import "UIColor+SR.h"

@interface ChallengeDetailVerificationController () {
  NSInteger _fakeCompleted;
  NSInteger _fakeRequired;
}

@end

@implementation ChallengeDetailVerificationController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor colorWithWhite:.9f alpha:1.f]];
  
  self.eldt = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,50.f, 175.f,175.f)];
  [self.eldt setCenter:CGPointMake(self.view.center.x,self.eldt.center.y - 20)];
  
  [self.eldt setDataSource:self];
  [self.eldt setDelegate:self];
  
  [self.eldt setAnimationSpeed:1.0];
  [self.view addSubview:self.eldt];
  
//    DTProgressElementLayout *pl = [[DTProgressElementLayout alloc] initWithIntent:[self.intents objectAtIndex:indexPath.section]];

  ChallengeDayDetail *cdd = [[ChallengeDayDetail alloc] initWithFrame:CGRectMake(0., 0., 200., 30)];
  [cdd setCenter:CGPointMake(self.view.frame.size.width/2.f,self.eldt.frame.origin.y + self.eldt.frame.size.height + 2.5)];
  [self.view addSubview:cdd];
    
}

-(void)verificationElement:(DTVerificationElement *)element didVerifySection:(NSUInteger)section
{
  NIDINFO(@"element: %@ and section:%d",element,section);
  [self performSelector:@selector(updateFakeCompleted) withObject:nil afterDelay:2.f];
}

- (void) updateFakeCompleted
{
  _fakeCompleted++;
  [self.eldt reloadData:NO];
}

- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element
{
  NSLog(@"fake completed: %d",_fakeCompleted);
  return _fakeCompleted; //numberCompleted
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  return _fakeRequired; //numberRequired
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _fakeCompleted = 1;
  _fakeRequired = 3;
  [self.eldt reloadData:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
