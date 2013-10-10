//
//  ProgressSnapshotView.m
//  daytoday
//
//  Created by pasmo on 10/2/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//
/*
 The progress snapshot consists of 2 weeks of day-circles with a DTProgressElement underlay to 
 indicate progress.
 
 The main functionalities of this view are essentially layout/composition of these views.
 
 * show 7 days in a row
 * proper spacing and padding so that view isn't jumbled
 * stacking of two rows of 7 day groups
 
 Eventually methods of creating these from actual server-side data will be a part of this but at the
 time of this writing I am not including that -- fagit ctory methods/logic will be rolled in after layout.
*/

#import "ProgressSnapshotView.h"
#import "DTProgressElementLayout.h"
#import "UIColor+SR.h"

@interface ProgressSnapshotView ()

@end

@implementation ProgressSnapshotView

static CGFloat ROW_SPACING = 4.f;
static CGFloat TOP_PADDING = 5.f;
//static int WEEK_ROWS = 2;

//layout two stacks of day rows
//determine which two weeks to display
//determine if start day is in the week

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DTProgressElementLayout *topRow = [[DTProgressElementLayout alloc] initWithFrame:CGRectMake(0.0,
                                                                                               TOP_PADDING,
                                                                                               self.frame.size.width,
                                                                                               self.frame.size.height)
                                                                        forDayInRow:6];
        [self addSubview:topRow];

        DTProgressElementLayout *bottomRow = [[DTProgressElementLayout alloc] initWithFrame:CGRectMake(0.0,
                                                                                               topRow.frame.origin.y + topRow.frame.size.height+ROW_SPACING,
                                                                                               self.frame.size.width,
                                                                                               self.frame.size.height)
                                                                        forDayInRow:6];
        [self addSubview:bottomRow];
    }
    return self;
}

@end
