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
@property (nonatomic,retain) NSNumber *dotNumber;
@property (nonatomic,retain) NSDate *dotDate;

- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andNumber:(NSNumber *)num;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andImage:(UIImage *)img;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andDate:(NSDate *)date;
@end
