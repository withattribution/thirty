//
//  ProfileSectionDateSeparatorView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "ProfileSectionDateSeparatorView.h"

@implementation ProfileSectionDateSeparatorView

static CGFloat DATE_PADDING = 3.0;

- (id)initWithFrame:(CGRect)frame andChallengeSpan:(NSString *)span
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((2*DATE_PADDING),
                                                                        0.0f,
                                                                        frame.size.width,
                                                                        frame.size.height)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        titleLabel.text = span;
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:titleLabel];
    }
    return self;
}

@end
