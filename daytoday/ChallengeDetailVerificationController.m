//
//  ChallengeDetailControllerViewController.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDetailVerificationController.h"
#import "DTVerificationElement.h"

#import "ChallengeDayDetail.h"
#import "DTSocialDashBoard.h"

@interface ChallengeDetailVerificationController () <DTVerificationElementDataSource,DTVerificationElementDelegate>

@property (nonatomic,strong) ChallengeDayDetail *cdd;

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
  
  self.verifyElement = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,50.f, 150.f,150.f)];
  [self.verifyElement setCenter:CGPointMake(self.view.center.x,self.verifyElement.center.y - 30)];
  
  [self.verifyElement setDataSource:self];
  [self.verifyElement setDelegate:self];
  
  [self.verifyElement setAnimationSpeed:1.0];
  [self.view addSubview:self.verifyElement];
  
  self.cdd = [[ChallengeDayDetail alloc] initWithFrame:CGRectMake(0., 0., 150., 30)
                                                               andDay:[[self.challengeDay objectForKey:kDTChallengeDayOrdinalDayKey] intValue]];
  [self.cdd setCenter:CGPointMake(self.view.frame.size.width/2.f,self.verifyElement.frame.origin.y + self.verifyElement.frame.size.height - 5.)];
  [self.view addSubview:self.cdd];
  
  BOOL hasActiveIntent = [[DTCache sharedCache] currentActiveIntentForUser:[PFUser currentUser]] != nil;
  if (!hasActiveIntent) {
    [DTCommonRequests queryIntentsForUser:[PFUser currentUser]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cachedIntentsForUser:)
                                                 name:DTIntentDidCacheIntentsForUserNotification
                                               object:nil];
  }else {
    [self addChallengeProgressElement];
  }
  
  


}

- (void)addChallengeProgressElement
{
  DTChallengeCalendar *cc = [DTChallengeCalendar calendarWithIntent:[[DTCache sharedCache] currentActiveIntentForUser:[PFUser currentUser]]];
  self.challengeProgressElement = [cc currentProgressElement];
  [self.challengeProgressElement setFrame:CGRectMake(0., 0., 320., 40.)];
  [self.challengeProgressElement setCenter:CGPointMake(self.view.frame.size.width/2.f, self.cdd.frame.origin.y + self.cdd.frame.size.height + 35.)];
  [self.view addSubview:self.challengeProgressElement];
}


- (CGFloat)heightForControllerFold
{
  return 240.f;
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
  NIDINFO(@"element: %@ and section:%d",element,section);
  if ([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] <
      [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]  &&
      ![[self.challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue])
  {
    PFObject *verification = [PFObject objectWithClassName:kDTVerificationClass];
    [verification setObject:@([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] +1)
                     forKey:kDTVerificationOrdinalKey];
    //if there is a verification status entered:
    //[verification setObject:VERIFICATION_STATUS forKey:kDTVerificationStatusContentKey];
#warning figure out how to propogate verfication type hardcoded for now
    [verification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        PFObject *verifyActivity = [PFObject objectWithClassName:kDTActivityClassKey];
        [verifyActivity setObject:kDTActivityTypeVerificationFinish forKey:kDTActivityTypeKey];
        verifyActivity[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
                                                                                   objectId:self.challengeDay.objectId];
        verifyActivity[kDTActivityVerificationKey] = [PFObject objectWithoutDataWithClassName:kDTVerificationClass
                                                                                     objectId:verification.objectId];
        [verifyActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
          if (succeeded) {
            NIDINFO(@"verification-tick saved!");
            [self.verifyElement reloadData:NO];
          }else {
            NIDINFO(@"%@",[error localizedDescription]);
          }
        }];
      }else {
        NIDINFO(@"%@",[error localizedDescription]);
      }
    }];
  }
}

#pragma mark - DTVerificationDataSource

- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element
{
  NIDINFO(@"completed: %d",[[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue]);
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue];
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  
  NIDINFO(@"the req count: %d",[[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]);
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue];
}

#pragma mark - Intents for User Cache Refreshed Notification

- (void)cachedIntentsForUser:(NSNotification *)aNotification
{
  [self addChallengeProgressElement];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTIntentDidCacheIntentsForUserNotification
                                                object:nil];
}

@end
