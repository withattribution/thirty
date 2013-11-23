//
//  ChallengeDescription.h
//  daytoday
//
//  Created by pasmo on 10/24/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeDescription : UIView <UITextViewDelegate>

@property (nonatomic,strong) NSString *description; //observed property

- (void)animateIntoView;
- (void)shouldBeFirstResponder;
- (void)descriptionDidComplete:(void (^)())block;

@end
