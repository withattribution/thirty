//
//  ChallengeDescription.h
//  daytoday
//
//  Created by pasmo on 10/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeDescription : UIView <UITextViewDelegate>

@property (strong, nonatomic) NSString *description;

- (void)shouldBeFirstResponder;
- (void)animateIntoView;
- (void)descriptionDidComplete:(void (^)())block;

@end
