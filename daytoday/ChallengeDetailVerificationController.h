//
//  ChallengeDetailControllerViewController.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2ViewController.h"
#import "DTVerificationElement.h"

@interface ChallengeDetailVerificationController : D2ViewController 

@property (nonatomic,strong) DTVerificationElement *eldt;

- (CGFloat)heightForControllerFold;

@end
