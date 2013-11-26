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

@property (nonatomic,strong) PFObject *challengeDay;

@end

//You can use a beforeSave validation in your Cloud Code which rejects the object if it's a duplicate. Let's say that you're storing these in a "BusStop" object and the bus stop identifier is stored as a string in stopId:
//
//var BusStop = Parse.Object.extend("BusStop");
//
//// Check if stopId is set, and enforce uniqueness based on the stopId column.
//Parse.Cloud.beforeSave("BusStop", function(request, response) {
//  if (!request.object.get("stopId")) {
//    response.error('A BusStop must have a stopId.');
//  } else {
//    var query = new Parse.Query(BusStop);
//    query.equalTo("stopId", request.object.get("stopId"));
//    query.first({
//    success: function(object) {
//      if (object) {
//        response.error("A BusStop with this stopId already exists.");
//      } else {
//        response.success();
//      }
//    },
//    error: function(error) {
//      response.error("Could not validate uniqueness for this BusStop object.");
//    }
//    });
//  }
//});

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
  
  self.verifyElement = [[DTVerificationElement alloc] initWithFrame:CGRectMake(50.f,50.f, 175.f,175.f)];
  [self.verifyElement setCenter:CGPointMake(self.view.center.x,self.verifyElement.center.y - 20)];
  
  [self.verifyElement setDataSource:self];
  [self.verifyElement setDelegate:self];
  
  [self.verifyElement setAnimationSpeed:1.0];
  [self.view addSubview:self.verifyElement];
  
//    DTProgressElementLayout *pl = [[DTProgressElementLayout alloc] initWithIntent:[self.intents objectAtIndex:indexPath.section]];

  ChallengeDayDetail *cdd = [[ChallengeDayDetail alloc] initWithFrame:CGRectMake(0., 0., 200., 30)
                                                               andDay:[[self.challengeDay objectForKey:kDTChallengeDayOrdinalDayKey] intValue]];
  [cdd setCenter:CGPointMake(self.view.frame.size.width/2.f,self.verifyElement.frame.origin.y + self.verifyElement.frame.size.height + 2.5)];
  [self.view addSubview:cdd];
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
  
//  if ([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] <
//      [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]  && )
//  {
//    [self.challengeDay incrementKey:kDTChallengeDayTaskCompletedCountKey];
//  }
//  [self.challengeDay saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//    if(succeeded){
//      
//    }else {
//      NIDINFO(@"%@",[error localizedDescription]);
//    }
//  }];

  if ([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] <
      [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue]  &&
      ![self.challengeDay objectForKey:kDTChallengeDayAccomplishedKey])
  {
    PFObject *verification = [PFObject objectWithClassName:kDTVerificationClass];
    [verification setObject:@([[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] +1)
                     forKey:kDTVerificationOrdinalKey];
    //if there is a verification status entered:
    //[verification setObject:VERIFICATION_STATUS forKey:kDTVerificationStatusContentKey];
#warning figure out how to propogate verfication type hardcoded for now
    [verification setObject:kDTVerificationTypeTick forKey:kDTVerificationTypeKey];

    [verification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        PFObject *verifyActivity = [PFObject objectWithClassName:kDTActivityClassKey];
        [verifyActivity setObject:kDTActivityTypeVerificationFinish forKey:kDTActivityTypeKey];
        verification[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey
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
//  NIDINFO(@"completed: %d",[[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue]);
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue];
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  return [[self.challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey] intValue];
}

@end
