//
//  DTDotColorGroup.m
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTDotColorGroup.h"

@implementation DTDotColorGroup

@synthesize textColor,strokeColor,fillColor;

+(DTDotColorGroup *) currentActiveDayColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor blackColor];
    dcg.fillColor   = [UIColor whiteColor];
    dcg.textColor  = [UIColor grayColor];
    return dcg;
}

+(DTDotColorGroup *) accomplishedDayColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor blueColor];
    dcg.textColor  = [UIColor whiteColor];
    return dcg;
}

+(DTDotColorGroup *) failedDayColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor lightGrayColor];
    dcg.textColor  = [UIColor grayColor];
    return dcg;
}

+(DTDotColorGroup *) repetitionCountColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor blueColor];
    dcg.textColor  = [UIColor whiteColor];
    return dcg;
}

+(DTDotColorGroup *) challengersCountColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor yellowColor]; //try to get okra color
    dcg.textColor  = [UIColor whiteColor];
    return dcg;
}

+(DTDotColorGroup *) summaryDayColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor lightGrayColor];
    dcg.textColor  = [UIColor grayColor];
    return dcg;
}

+(DTDotColorGroup *) summaryPercentageColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor clearColor];
    dcg.fillColor   = [UIColor blueColor];
    dcg.textColor  = [UIColor whiteColor];
    return dcg;
}

+(DTDotColorGroup *) daySelectionColorGroup
{
    DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
    dcg.strokeColor = [UIColor lightGrayColor];
    dcg.fillColor   = [UIColor grayColor];
    dcg.textColor  = [UIColor whiteColor];
    return dcg;
}

@end
