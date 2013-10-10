//
//  DTProgressElementLayout.h
//  daytoday
//
//  Created by pasmo on 10/3/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTProgressElementLayout : UIView

- (id)initWithFrame:(CGRect)frame forDayInRow:(int)day;
- (id)initWithFrame:(CGRect)frame forSummaryWithPercent:(CGFloat)percentComplete;

@end
