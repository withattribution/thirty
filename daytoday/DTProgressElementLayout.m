//
//  DTProgressElementLayout.m
//  daytoday
//
//  Created by pasmo on 10/3/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTProgressElementLayout.h"
#import "DTProgressElement.h"
#import "DTDotElement.h"
#import "DTDotColorGroup.h"
#import "DTProgressColorGroup.h"

// the progress element for the 2 week snapshot
// two rows of days with a progress meter that accepts the number of days that the progress should cover
// both margins and a flat left edge and round right edge
// rounded left edge if first day (not flat edge)
//
// the progress element for the 1 week detail view
// flat left edge, spaced equally for each margin
// rounded right edge
// should take a day to indicate the amount of progress should be shown

@interface DTProgressElementLayout (){
    DTProgressElement* pElement;
    CGFloat DTDotElementFrameWidth;
    CGFloat progress;
}

@end

@implementation DTProgressElementLayout

static int NUM_DAYS_FOR_ROW = 7;
static CGFloat EDGE_PADDING = 3.f;

- (id)initWithFrame:(CGRect)frame forDayInRow:(int)day
{
    self = [super initWithFrame:frame];
    if (self) {
        DTDotElementFrameWidth = [self getFrameWidth];
        progress = DTDotElementFrameWidth * day;

        pElement = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.0f,
                                                                       0.0f,
                                                                       self.frame.size.width,
                                                                       self.frame.size.height)
                                                                 andColorGroup:[DTProgressColorGroup snapshotProgress]
                                                                 progressUnits:progress];
//        if(row is for previous week) {
//            if(row contains start-day){
            [pElement drawFlatRightProgressElement];
//           else {
//            [pElement drawFlatProgressElement];
//            }
//        }else{
//            if(row contains start-day){
//            [pElement drawRoundedProgressElement];
//            else {
//            [pElement drawFlatLeftProgressElement];
//            }
//        }
        [self addSubview:pElement];
        [self drawDTDotElementsForDays:NUM_DAYS_FOR_ROW];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame forSummaryWithPercent:(CGFloat)percentComplete
{
    self = [super initWithFrame:frame];
    if (self) {
        progress = percentComplete;
        [self dayProgressSummary];
    }
    return self;
}

- (CGFloat)getFrameWidth
{
    return (self.frame.size.width - (2*EDGE_PADDING)) / NUM_DAYS_FOR_ROW;
}

//#TODO NEED TO LABEL WITH ACTUAL DAY NUMBER
- (void)drawDTDotElementsForDays:(int)days
{
    for (int i = 0; i < NUM_DAYS_FOR_ROW; i++) {
        CGRect DTDotElementFrame = CGRectMake(i*DTDotElementFrameWidth+EDGE_PADDING,
                                              0.,
                                              pElement.frame.size.height,
                                              pElement.frame.size.height);
        
        DTDotElement *element = [[DTDotElement alloc] initWithFrame:DTDotElementFrame
                                                            andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
                                                                andNumber:[NSNumber numberWithInt:i]];
        [self addSubview:element];
    }
}

// the progress element for the summary
// two days centered vertically and at each endpoint spaced from left and right edges of the screen
// both ends rounded and spaced with equal margins
// unlayer with clear or white fill and colored stroke to imitate progress view
- (void)dayProgressSummary
{
    DTProgressElement *summaryProgressBackground = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.f,
                                                                                                       0.f,
                                                                                                       self.frame.size.width,
                                                                                                       self.frame.size.height)
                                                                              andColorGroup:[DTProgressColorGroup summaryProgressBackground]
                                                                                withPercent:1.f];
    [self addSubview:summaryProgressBackground];
    
    DTProgressElement *summaryProgressForeground = [[DTProgressElement alloc] initWithFrame:CGRectMake(0.f,
                                                                                                       0.f,
                                                                                                       self.frame.size.width ,
                                                                                                       self.frame.size.height)
                                                                              andColorGroup:[DTProgressColorGroup summaryProgressForeground]
                                                                                withPercent:progress];
    [summaryProgressBackground leftCenter];
    [self addSubview:summaryProgressForeground];
    
    DTDotElement *startDay = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f,
                                                                            0.f,
                                                                            summaryProgressForeground.frame.size.height,
                                                                            summaryProgressForeground.frame.size.height)
                                                   andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                       andNumber:[NSNumber numberWithInt:11]];
    [startDay setCenter:[summaryProgressForeground leftCenter]];
    [summaryProgressForeground addSubview:startDay];
    
    DTDotElement *endDay = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f,
                                                                          0.f,
                                                                          self.frame.size.height,
                                                                          self.frame.size.height)
                                                 andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                     andNumber:[NSNumber numberWithInt:28]];
    
    [endDay setCenter:[summaryProgressForeground rightCenter]];
    [self addSubview:endDay];
}

@end
