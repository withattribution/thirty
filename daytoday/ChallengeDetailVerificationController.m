//
//  ChallengeDetailControllerViewController.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDetailVerificationController.h"
#import "VerificationStatusController.h"

#import "Verification.h"
#import "DTVerificationElement.h"

#import "ChallengeDayDetail.h"
#import "DTSocialDashBoard.h"
#import "DTChallengeCalendar.h"
#import "DTProgressRow.h"

@interface ChallengeDetailVerificationController () <DTVerificationElementDataSource,DTVerificationElementDelegate,DTProgressRowDelegate>

@property (nonatomic,strong) ChallengeDayDetail *cdd;
@property (nonatomic,strong) DTProgressRow *rowView;
@property (nonatomic,strong) DTChallengeCalendar *calendarObject;

@end

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
  
  self.frequencyDot = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f) andColorGroup:[DTDotColorGroup frequenctCountColorGroup] andNumber:remaining];
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



- (BOOL)intentHasChallengeDays
{
  return [[DTCache sharedCache] challengeDaysForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]] != nil;
}

- (void)addChallengeProgressElement
{
  if(![self intentHasChallengeDays]) {
    [DTCommonRequests requestDaysForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] cachePolicy:kPFCachePolicyNetworkOnly];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cachedChallengeDaysForIntent:)
                                                 name:DTChallengeDayDidCacheDaysForIntentNotification
                                               object:nil];
  }
  
  self.calendarObject = [DTChallengeCalendar calendarWithIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
  
  self.rowView = [[DTProgressRow alloc] initWithFrame:CGRectMake(0.f, self.cdd.frame.origin.y + self.cdd.frame.size.height + 15., self.view.frame.size.width, 40.f)];
//  [self.rowView setCenter:CGPointMake(self.view.frame.size.width/2.f, self.cdd.frame.origin.y + self.cdd.frame.size.height + 35.)];

  [self.rowView setDelegate:self];
  [self.rowView setDataSource:self.calendarObject];
  [self.view addSubview:self.rowView];
}

- (CGFloat)heightForControllerFold
{
  return 285.f;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.verifyElement reloadData:YES];
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
  VerificationStatusController *vc = [[VerificationStatusController alloc] init];
  [self.parentViewController.view addSubview:vc.view];

//  NIDINFO(@"element: %@ and section:%d",element,section);
//  if ([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] <
//      [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]  &&
//      ![[self.challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue])
//  {
//    PFObject *verification = [PFObject objectWithClassName:kDTVerificationClass];
//    [verification setObject:@([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] +1)
//                     forKey:kDTVerificationOrdinalKey];
//    //if there is a verification status entered:
//    //[verification setObject:VERIFICATION_STATUS forKey:kDTVerificationStatusContentKey];
//#warning figure out how to propogate verfication type hardcoded for now
//    [verification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//      if (succeeded) {
//        PFObject *verifyActivity = [PFObject objectWithClassName:kDTActivityClassKey];
//        [verifyActivity setObject:kDTActivityTypeVerificationFinish forKey:kDTActivityTypeKey];
//        verifyActivity[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
//                                                                                   objectId:self.challengeDay.objectId];
//        verifyActivity[kDTActivityVerificationKey] = [PFObject objectWithoutDataWithClassName:kDTVerificationClass
//                                                                                     objectId:verification.objectId];
//        [verifyActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//          if (succeeded) {
//            NIDINFO(@"verification-tick saved!");
//            [self.challengeDay fetchInBackgroundWithBlock:^(PFObject *day, NSError *error){
//              if(!error && day){
//                self.challengeDay = day;
//                [self.verifyElement reloadData:NO];
//              }
//            }];
//          }else {
//            NIDINFO(@"%@",[error localizedDescription]);
//          }
//        }];
//      }else {
//        NIDINFO(@"%@",[error localizedDescription]);
//      }
//    }];
//  }
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

#pragma mark - Intents for User Cache Refreshed Notification

- (void)cachedChallengeDaysForIntent:(NSNotification *)aNotification
{
  [self.rowView reloadData:YES date:[NSDate date]];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTChallengeDayDidCacheDaysForIntentNotification
                                                object:nil];
}

@end
