//
//  DTProgressElement.h
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Intent+D2D.h"
#import "ChallengeDay+D2D.h"
#import "Challenge+D2D.h"

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

@interface DTProgressColorGroup : NSObject

+(DTProgressColorGroup *) summaryProgressBackground;
+(DTProgressColorGroup *) summaryProgressForeground;
+(DTProgressColorGroup *) snapshotProgress;

@property (nonatomic, strong) UIColor* strokeColor;
@property (nonatomic, strong) UIColor* fillColor;

@end


//return an object that holds onto the progress elements that
//will be used in particular views
//for instance:
//the profile progress snapshot view
//the challenge detail progress view
//the summary progress view

@interface DTProgressElementLayout : NSObject

@property (nonatomic,retain) Intent *intent;
@property (nonatomic,retain) NSArray *weekRows; //Array of arrays with dotWeeks-rows for progressElement rows

@property (nonatomic,retain) UIView *layoutView;

- (id)initWithIntent:(Intent *)i;
- (id)initWithRow:(NSArray *)weekRow withIntent:(Intent *)i;
- (DTProgressRowTemporalStatus)temporalStatusForRow;
- (DTProgressRowEndStyle)endStyleForRow;

//- (id)initWithFrame:(CGRect)frame forDayInRow:(int)day;
//- (id)initWithFrame:(CGRect)frame forSummaryWithPercent:(CGFloat)percentComplete;

@end

@interface DTProgressElement : UIView

@property (nonatomic) CGPoint leftCenter;
@property (nonatomic) CGPoint rightCenter;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;

//- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p;
//- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units;

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p;
- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units;

- (void)drawFlatProgressElement;
- (void)drawFlatLeftProgressElement;
- (void)drawFlatRightProgressElement;
- (void)drawRoundedProgressElement;

- (CGPoint)rightCenter;
- (CGPoint)leftCenter;

@end

