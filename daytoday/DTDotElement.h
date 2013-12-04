//
//  DTDotElement.h
//  daytoday
//
//  Created by pasmo on 9/5/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDotColorGroup : NSObject

+(DTDotColorGroup *) currentActiveDayColorGroup;
+(DTDotColorGroup *) accomplishedDayColorGroup;
+(DTDotColorGroup *) someParticipationAndStillActiveColorGroup;
+(DTDotColorGroup *) someParticipationButFailedColorGroup;
+(DTDotColorGroup *) failedDayColorGroup;
+(DTDotColorGroup *) futuresSoBrightYouGottaWearShadesColorGroup;
+(DTDotColorGroup *) durationSelectionColorGroup;
+(DTDotColorGroup *) repetitionCountColorGroup;
+(DTDotColorGroup *) challengersCountColorGroup;
+(DTDotColorGroup *) summaryDayColorGroup;
+(DTDotColorGroup *) summaryPercentageColorGroup;

+ (DTDotColorGroup *) colorGroupForChallengeDay:(PFObject *)challengeDay;

@property (nonatomic, strong) UIColor* strokeColor;
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* textColor;

@end

@interface DTDotElement : UIView

@property (nonatomic) CGFloat radius;
@property (nonatomic,retain) NSNumber *dotNumber;
@property (nonatomic,retain) NSDate *dotDate;
@property (nonatomic,retain) UIImage *dotImage;

+ (DTDotElement *)buildForChallengeDay:(PFObject *)challengeDay andDate:(NSDate *)date;

- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andNumber:(NSNumber *)num;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andImage:(UIImage *)img;
- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg andDate:(NSDate *)date;

@end
