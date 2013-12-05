//
//  ProfileSectionHeaderView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "ProfileSectionHeaderView.h"


@implementation ProfileSectionHeaderView
@synthesize challengeLabel,sectionImageView;

static CGFloat TEXT_PADDING = 3.0f;
static CGFloat TEXT_BACKING_HEIGHT = 35.f;

static CGFloat SECTION_IMAGE_HEIGHT = 110.f;
static CGFloat SECTION_IMAGE_WIDTH = 320.f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"sectionImageHolder.jpg"]];
        [self.contentView addSubview:self.sectionImageView];
        
        UIView *textBacking = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                       SECTION_IMAGE_HEIGHT - TEXT_BACKING_HEIGHT,
                                                                       SECTION_IMAGE_WIDTH,
                                                                       TEXT_BACKING_HEIGHT)];
        
        [textBacking setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:.75]];
        [self.sectionImageView addSubview:textBacking];
        
        self.challengeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PADDING,
                                                                        textBacking.frame.origin.y,
                                                                        SECTION_IMAGE_WIDTH,
                                                                        TEXT_BACKING_HEIGHT)];
        self.challengeLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.f];
        self.challengeLabel.backgroundColor = [UIColor clearColor];
        self.challengeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.challengeLabel.text = @"TEST LABEL";
        self.challengeLabel.numberOfLines = 1;
        self.challengeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.challengeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.sectionImageView addSubview:self.challengeLabel];
    }
    return self;
}

@end
