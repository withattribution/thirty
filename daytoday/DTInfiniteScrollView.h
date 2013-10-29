//
//  DTInfiniteScrollView.h
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//


//Warning -- be advised that this view currently requires that the
//array of views to be displayed should be tags in a sequential order
//otherwise funny business occurs -- not the good kinds

#import <UIKit/UIKit.h>

@interface DTInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame views:(NSArray *)views;

@end
