//
//  ChallengeDetailControllerViewController.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTViewController.h"
#import "DTVerificationElement.h"
#import "DTDotElement.h"
#import "DTProgressElement.h"

@interface ChallengeDetailVerificationController : DTViewController

@property (nonatomic,strong) DTVerificationElement *verifyElement;
@property (nonatomic,strong) PFObject *challengeDay;
@property (nonatomic,strong) DTProgressElement *challengeProgressElement;
@property (nonatomic,strong) DTDotElement *frequencyDot;

- (id)initWithChallengeDay:(PFObject *)chDay;

- (CGFloat)heightForControllerFold;

@end
