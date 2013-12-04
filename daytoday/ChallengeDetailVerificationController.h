//
//  ChallengeDetailControllerViewController.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTViewController.h"
#import "DTVerificationElement.h"

@interface ChallengeDetailVerificationController : DTViewController

@property (nonatomic,strong) DTVerificationElement *verifyElement;

- (id)initWithChallengeDay:(PFObject *)chDay;

- (CGFloat)heightForControllerFold;

@end
