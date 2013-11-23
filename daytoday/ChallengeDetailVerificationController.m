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

@interface ChallengeDetailVerificationController () <DTVerificationElementDataSource,DTVerificationElementDelegate> {
  NSInteger _fakeCompleted;
  NSInteger _fakeRequired;
}

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

- (CGFloat)heightForControllerFold
{
  
  
  return 240.f;
}



- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _fakeCompleted = 1;
  _fakeRequired = 6;
  [self.eldt reloadData:YES];
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
  [self performSelector:@selector(updateFakeCompleted) withObject:nil afterDelay:2.f];
}

- (void) updateFakeCompleted
{
  _fakeCompleted++;
  [self.eldt reloadData:NO];
}

#pragma mark - DTVerificationDataSource

- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element
{
//  NSLog(@"fake completed: %d",_fakeCompleted);
  return _fakeCompleted; //numberCompleted
}

-(NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement
{
  return _fakeRequired; //numberRequired
}

@end
