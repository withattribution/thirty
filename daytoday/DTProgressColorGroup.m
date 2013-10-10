//
//  DTProgressColorGroup.m
//  daytoday
//
//  Created by pasmo on 10/3/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTProgressColorGroup.h"

@implementation DTProgressColorGroup

@synthesize strokeColor,fillColor;

+(DTProgressColorGroup *) summaryProgressBackground
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor redColor];
    pcg.fillColor   = [UIColor whiteColor];
    return pcg;
}

+(DTProgressColorGroup *) summaryProgressForeground
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor redColor];
    pcg.fillColor   = [UIColor redColor];
    return pcg;
}


+(DTProgressColorGroup *) snapshotProgress
{
    DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
    pcg.strokeColor = [UIColor blueColor];
    pcg.fillColor   = [UIColor blueColor];
    return pcg;
}

@end
