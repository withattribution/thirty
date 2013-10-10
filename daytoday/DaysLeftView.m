//
//  DaysLeftView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DaysLeftView.h"
#import "DTDotElement.h"
#import "DTDotColorGroup.h"
#import "DTCaret.h"

@implementation DaysLeftView

static CGFloat DAY_PADDING = 3.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DTDotElement *dLeft = [[DTDotElement alloc] initWithFrame:CGRectMake(DAY_PADDING,
                                                                             0,
                                                                             self.frame.size.height-(2*DAY_PADDING),
                                                                             self.frame.size.height-(1*DAY_PADDING))
                                                    andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                        andNumber:[NSNumber numberWithInt:20]];

        UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(dLeft.frame.size.width+(2*DAY_PADDING),
                                                                       0,
                                                                       frame.size.width,
                                                                       frame.size.height)];
        daysLabel.textColor = [UIColor darkGrayColor];
        daysLabel.backgroundColor = [UIColor clearColor];
        daysLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        daysLabel.text = @"DAYS LEFT";
        daysLabel.numberOfLines = 1;
        daysLabel.textAlignment = NSTextAlignmentLeft;

        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:95]];
        
        DTCaret *c = [[DTCaret alloc] initWithFrame:CGRectMake(0.f, 0.f, 14.f, 14.f)];
        c.frame = CGRectMake(dLeft.center.x - c.center.x + DAY_PADDING/2.0,
                             c.frame.origin.y,
                             c.frame.size.width,
                             c.frame.size.height);

        [self addSubview:dLeft];
        [self addSubview:daysLabel];
        [self addSubview:c];
    }
    return self;
}
@end
