//
//  DTProgressElement.h
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTProgressColorGroup.h"

@interface DTProgressElement : UIView

@property (nonatomic) CGPoint leftCenter;
@property (nonatomic) CGPoint rightCenter;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p;
- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units;

- (void)drawFlatProgressElement;
- (void)drawFlatLeftProgressElement;
- (void)drawFlatRightProgressElement;
- (void)drawRoundedProgressElement;

- (CGPoint)rightCenter;
- (CGPoint)leftCenter;

@end

