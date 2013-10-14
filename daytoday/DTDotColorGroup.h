//
//  DTDotColorGroup.h
//  daytoday
//
//  Created by pasmo on 10/1/13.
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

+(DTDotColorGroup *) repetitionCountColorGroup;

+(DTDotColorGroup *) challengersCountColorGroup;

+(DTDotColorGroup *) summaryDayColorGroup;

+(DTDotColorGroup *) summaryPercentageColorGroup;

@property (nonatomic, strong) UIColor* strokeColor;
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* textColor;

@end
