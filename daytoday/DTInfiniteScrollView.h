//
//  DTInfiniteScrollView.h
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views;

@end
