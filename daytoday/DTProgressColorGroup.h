//
//  DTProgressColorGroup.h
//  daytoday
//
//  Created by pasmo on 10/3/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTProgressColorGroup : NSObject

+(DTProgressColorGroup *) summaryProgressBackground;

+(DTProgressColorGroup *) summaryProgressForeground;

+(DTProgressColorGroup *) snapshotProgress;

@property (nonatomic, strong) UIColor* strokeColor;
@property (nonatomic, strong) UIColor* fillColor;

@end
