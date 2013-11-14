//
//  ChallengeDetailControllerViewController.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2ViewController.h"
#import "DTVerificationElement.h"

@protocol ChallengeDetailVerificationControllerDelegate <NSObject>
@optional
- (void)moveControllerToTop;
- (void)moveControllerToOriginalPosition;
@end

@interface ChallengeDetailVerificationController : D2ViewController <DTVerificationElementDataSource,DTVerificationElementDelegate>

@property (nonatomic,weak) id<ChallengeDetailVerificationControllerDelegate> delegate;
@property (nonatomic,strong) DTVerificationElement *eldt;

@end
