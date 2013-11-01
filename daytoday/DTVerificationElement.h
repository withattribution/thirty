//
//  DTVerificationElement.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTVerificationElement : UIView

@property (nonatomic,assign) CGFloat dotRadius;
@property (nonatomic,assign) CGPoint dotCenter;

- (void)drawVerificationSection;

@end
