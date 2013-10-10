//
//  ProfileSectionHeaderView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "ProfileSectionHeaderView.h"
#import "TitleOverlayView.h"
#import "ProfileSectionHeaderImageView.h"
#import "ProfileSectionDateSeparatorView.h"

//1 a uilable view with specific 2 line layout constraints with a light color backing
//2 a center-cropped uiimage
//3 a date line with a darker background with the start and end months of the challenge

@implementation ProfileSectionHeaderView

static CGFloat PERCENT_WINDOW_BOUNDS = 0.50f;
static CGFloat OVERLAY_PADDING = 5.0f;
static CGFloat SEPARATOR_WIDTH = 14.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        ProfileSectionHeaderImageView *header = [[ProfileSectionHeaderImageView alloc] initWithFrame:CGRectMake(0.0,
                                                                                                                0.0,
                                                                                                                self.frame.size.width,
                                                                                                                0.0)
                                                                                           withImage:[UIImage imageNamed:@"anotherCrop.jpg"]];
        header.frame = CGRectMake(0.0,0.0,header.headerImage.size.width,header.headerImage.size.height);
        [self addSubview:header];

        TitleOverlayView *overlay = [[TitleOverlayView alloc] initWithFrame:CGRectMake(0.0,
                                                                                       OVERLAY_PADDING,
                                                                                       [self overlayWidth],
                                                                                       0.0)
                                                                   andTitle:@"TAKE A SELFIE EVERY DAMN DAY"];

        CGRect overlayFrame = CGRectMake(header.frame.size.width - (overlay.frame.size.width + OVERLAY_PADDING),
                                         OVERLAY_PADDING,
                                         overlay.frame.size.width,
                                         overlay.frame.size.height);
        overlay.frame = overlayFrame;
        [header addSubview:overlay];

        ProfileSectionDateSeparatorView *sep = [[ProfileSectionDateSeparatorView alloc] initWithFrame:CGRectMake(0,
                                                                                                                 header.frame.size.height,
                                                                                                                 frame.size.width,
                                                                                                                 SEPARATOR_WIDTH)
                                                                                     andChallengeSpan:@"JUNE - JULY 2013"];
        [self addSubview:sep];
    }
    return self;
}

- (CGFloat)overlayWidth
{
    // fix to some percentage of the window bounds
    return [[UIScreen mainScreen] bounds].size.width*(PERCENT_WINDOW_BOUNDS);
}
@end
