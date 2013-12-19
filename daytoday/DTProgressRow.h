//
//  DTProgressRow.h
//  daytoday
//
//  Created by pasmo on 12/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDotElement.h"
#import "DTProgressElement.h"

typedef NS_ENUM(NSInteger, DTProgressRowTemporalStatus) {
  DTProgressRowPast,
  DTProgressRowCurrent,
  DTProgressRowFuture,
  DTProgressRowTemporalStatusUndefined
};

@class DTProgressRow;
@protocol DTProgressRowDelegate <NSObject>

@optional
- (void)userDidSelectDot:(DTDotElement *)dot forRow:(DTProgressRow *)row;
@end

@protocol DTProgressRowDataSource <NSObject>

@required
- (NSUInteger)numberOfDaysForProgressRow:(DTProgressRow *)row;
- (NSArray *)datesForProgressRow:(DTProgressRow *)row date:(NSDate *)date;
- (NSArray *)challengeDaysForProgressRow:(DTProgressRow *)row date:(NSDate *)date;
- (NSUInteger)indexForDate:(DTProgressRow *)row date:(NSDate *)date;
- (DTProgressRowEndStyle)endStyleForProgressRow:(DTProgressRow *)row date:(NSDate *)date;
@end

@interface DTProgressRow : UIView

@property (nonatomic,assign) CGFloat rowInset;

@property (nonatomic,weak) id<DTProgressRowDataSource> dataSource;
@property (nonatomic,weak) id<DTProgressRowDelegate> delegate;

- (void)reloadData:(BOOL)animated date:(NSDate *)date;
@end
