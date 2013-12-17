//
//  VerificationStatusController.m
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "VerificationStatusController.h"
#import "VerificationStatusInput.h"

@interface VerificationStatusController () <VerificationStatusInputDelegate>

@end

@implementation VerificationStatusController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:0.85f]];
  
  VerificationStatusInput *statusInput = [[VerificationStatusInput alloc] initWithFrame:CGRectMake(0., 20.f, 320.f, 320.f)];
  [statusInput setDelegate:self];
  [statusInput setUser:[PFUser currentUser]];
  [statusInput setContentText:@"first task of the day"];
  [self.view addSubview:statusInput];
  
//  PFObject *intent = [[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]];
//  PFObject *challenge = [[DTCache sharedCache] challengeForIntent:intent];
  
  NIDINFO(@"the intent ID: %@",[[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] objectId]);
  
  PFObject *cachedChallenge = [[DTCache sharedCache] challengeForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];

  
//  NIDINFO(@"the cached intent object: %@",intent);
  NIDINFO(@"the cached challenge object: %@",cachedChallenge);
  
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VerificationStatusInput Delegate Methods

- (void)statusInput:(VerificationStatusInput *)view didTapOkButton:(UIButton *)aButton textView:(UITextView *)textView
{
  
}

@end
