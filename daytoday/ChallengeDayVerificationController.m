//
//  ChallengeDetailControllerViewController.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDayVerificationController.h"
#import "VerificationFlowController.h"

#import "Verification.h"
#import "DTVerificationElement.h"
#import "DTVerificationCell.h"

#import "ChallengeDayDetail.h"
#import "DTChallengeCalendar.h"
#import "DTProgressRow.h"

@interface ChallengeDetailVerificationController () <DTVerificationElementDataSource,
                                                       DTVerificationElementDelegate,
                                                               DTProgressRowDelegate>

@property (nonatomic,strong) VerificationFlowController *verificationFlow;
@property (nonatomic,strong) ChallengeDayDetail *cdd;
@property (nonatomic,strong) DTProgressRow *rowView;
@property (nonatomic,strong) DTChallengeCalendar *calendarObject;

@end

#define kVerificationDayInset 5.f

@implementation ChallengeDetailVerificationController

- (id)initWithChallengeDay:(PFObject *)chDay
{
  self = [super init];
  if(self){
    self.challengeDay = chDay;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithWhite:.9f alpha:1.f]];

  self.verifyElement = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,95.f, 150.f,150.f)];
  [self.verifyElement setCenter:CGPointMake(self.view.center.x,self.verifyElement.center.y - 30)];
  [self.verifyElement setDataSource:self];
  [self.verifyElement setDelegate:self];
  [self.verifyElement setType:DTVerificationTickMark];
  [self.verifyElement setAnimationSpeed:1.0];
  [self.view addSubview:self.verifyElement];
  
  NSNumber *remaining = [NSNumber numberWithInt:
                         [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue] -
                         [[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue]];
  
  self.frequencyDot = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f) andColorGroup:[DTDotColorGroup frequencyCountColorGroup] andNumber:remaining];
  [self.frequencyDot setAlpha:0.80];
  [self.frequencyDot setUserInteractionEnabled:NO];
  [self.frequencyDot setCenter:self.verifyElement.center];
  [self.view addSubview:self.frequencyDot];
  
  self.cdd = [[ChallengeDayDetail alloc] initWithFrame:CGRectMake(0., 0., 150., 30)
                                                               andDay:[[self.challengeDay objectForKey:kDTChallengeDayOrdinalDayKey] intValue]];
  [self.cdd setCenter:CGPointMake(self.view.frame.size.width/2.f,self.verifyElement.frame.origin.y + self.verifyElement.frame.size.height - 5.)];
  [self.view addSubview:self.cdd];
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  [self addChallengeProgressElement];
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

- (void)addChallengeProgressElement
{
  [[DTCommonRequests retrieveDaysForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]]
   continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *ts){
    if (!ts.error) {
      self.calendarObject = [DTChallengeCalendar calendarWithIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
      self.rowView = [[DTProgressRow alloc] initWithFrame:CGRectMake(0.f, self.cdd.frame.origin.y + self.cdd.frame.size.height + 15., self.view.frame.size.width, 40.f)];
      
      [self.rowView setDelegate:self];
      [self.rowView setDataSource:self.calendarObject];
      [self.rowView setRowInset:kVerificationDayInset];
      [self.view addSubview:self.rowView];
      //this need this to be called before it is drawn to the screen and that seems wrong wrong wrong
#warning wrong wrong wrong !!!
      [self.rowView reloadData:YES date:[NSDate date]];
    }

    return nil;
  }];
}

- (CGFloat)heightForControllerFold
{
  return 285.f;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.verifyElement reloadData:YES];
  
  [self.rowView reloadData:NO date:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - DTVerificationDelegate 

-(void)verificationElement:(DTVerificationElement *)element didVerifySection:(NSUInteger)section
{
  NIDINFO(@"element: %@ and section:%lu",element,(unsigned long)section);
  if ([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] <
      [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]  &&
      ![[self.challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue])
  {
    self.verificationFlow = [[VerificationFlowController alloc] init];
    [self.parentViewController addChildViewController:self.verificationFlow];
    [self.parentViewController.view addSubview:self.verificationFlow.view];
    [self.verificationFlow didMoveToParentViewController:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedChallengeDay:)
                                                 name:DTChallengeDayDidCacheDayNotification
                                               object:nil];
  }
}

#pragma mark - DTVerificationDataSource

- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element
{
  NIDINFO(@"completed: %d",[[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue]);
  NSNumber *remaining = [NSNumber numberWithInt:
                         [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue] -
                         [[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue]];
  [self.frequencyDot setDotNumber:remaining];
  
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue];
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  NIDINFO(@"the req count: %d",[[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]);
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue];
}


#pragma mark - Challenge Day Refreshed Notification

- (void)updatedChallengeDay:(NSNotification *)aNotification
{
  NIDINFO(@"full circle back to verifcation reloading -- does this work if it's not on screen?");
  if (aNotification.object != nil) {
    [self.verificationFlow dismissStatusUpdateTableView];
    self.challengeDay = aNotification.object;
    [self.verifyElement reloadData:NO];
  }else{
    NIDINFO(@"some kind of error updating the challenge day object");
  }

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTChallengeDayDidCacheDayNotification
                                                object:nil];
}

@end
