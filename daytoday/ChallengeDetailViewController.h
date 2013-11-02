//
//  ChallengeDetailControllerViewController.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2ViewController.h"
#import "DTVerificationElement.h"

@interface ChallengeDetailViewController : D2ViewController <DTVerificationElementDataSource>

@property (nonatomic,strong) DTVerificationElement *eldt;

@end
