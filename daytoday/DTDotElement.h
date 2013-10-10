//
//  DTDotElement.h
//  daytoday
//
//  Created by pasmo on 9/5/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDotColorGroup.h"

@interface DTDotElement : UIView

@property (nonatomic) CGFloat radius;

- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andNumber:(NSNumber *)num;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andImage:(UIImage *)img;

@end
