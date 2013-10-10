//
//  TitleOverlayView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "TitleOverlayView.h"

@implementation TitleOverlayView

static CGFloat TITLE_PADDING = 2.0f;
static CGFloat MIN_WIDTH = 100.0f;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)t
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize tSize = [t sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]
                       constrainedToSize:CGSizeMake(self.frame.size.width - (2*TITLE_PADDING),CGFLOAT_MAX)];

        if (tSize.width < MIN_WIDTH) tSize.width = MIN_WIDTH;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_PADDING,
                                                                        0.0f,
                                                                        tSize.width,
                                                                        tSize.height)];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:.95];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        titleLabel.text = t;
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textAlignment = NSTextAlignmentLeft;

        UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                       0.0f,
                                                                       TITLE_PADDING,
                                                                       titleLabel.frame.size.height)];
        [leftPadding setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:.95]];

        self.frame = CGRectMake(0.0f, 0.0f, leftPadding.frame.size.width+titleLabel.frame.size.width, tSize.height);
        [self addSubview:leftPadding];
        [self addSubview:titleLabel];
    }
    return self;
}

@end

