//
//  DTProgressElement.h
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTProgressRowEndStyle) {
    DTProgressRowEndFlat,
    DTProgressRowEndFlatLeft,
    DTProgressRowEndFlatRight,
    DTProgressRowEndBothRounded,
    DTProgressRowEndUndefined
};

typedef NS_ENUM(NSInteger, DTProgressRowTemporalStatus) {
    DTProgressRowPast,
    DTProgressRowCurrent,
    DTProgressRowFuture,
    DTProgressRowTemporalStatusUndefined
};

@interface DTProgressRow : NSObject

@property (nonatomic) DTProgressRowEndStyle style;
@property (nonatomic) DTProgressRowTemporalStatus phase;
@property (nonatomic,strong) NSArray *weekRow;           //Row of DTDotElements for challenge calendar

+ (DTProgressRow *)withEndStyle:(DTProgressRowEndStyle)end
                          phase:(DTProgressRowTemporalStatus)status
                            row:(NSArray *)row;

@end

@interface DTProgressColorGroup : NSObject

+ (DTProgressColorGroup *) summaryProgressBackground;
+ (DTProgressColorGroup *) summaryProgressForeground;
+ (DTProgressColorGroup *) snapshotProgress;

@property (nonatomic,strong) UIColor* strokeColor;
@property (nonatomic,strong) UIColor* fillColor;

@end

@class DTProgressElement;
@interface DTChallengeCalendar : NSObject

+ (DTChallengeCalendar *)calendarWithIntent:(PFObject *)intent;

- (DTProgressElement *)currentProgressElement;
- (NSArray *)progressSnapShotElements;
- (UIView *)summaryProgressView;

@end

@interface DTProgressElement : UIView

@property (nonatomic,assign) CGPoint leftCenter;
@property (nonatomic,assign) CGPoint rightCenter;
@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,assign) CGFloat radius;

- (id)initForSummaryElement:(CGFloat)p;
- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units;

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p;
- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units;

- (void)drawFlatProgressElement;
- (void)drawFlatLeftProgressElement;
- (void)drawFlatRightProgressElement;
- (void)drawRoundedProgressElement;

- (CGPoint)rightCenter;
- (CGPoint)leftCenter;

@end

