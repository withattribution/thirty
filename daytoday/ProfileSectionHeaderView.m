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

#import "UIColor+SR.h"

//1 a uilable view with specific 2 line layout constraints with a light color backing
//2 a center-cropped uiimage
//3 a date line with a darker background with the start and end months of the challenge

@implementation ProfileSectionHeaderView

static CGFloat PERCENT_WINDOW_BOUNDS = 0.50f;
static CGFloat OVERLAY_PADDING = 5.0f;
static CGFloat SEPARATOR_WIDTH = 14.0f;

static NSString *sectionHeaderViewReuseIdentifier = @"sectionHeaderViewReuseIdentifier";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ProfileSectionHeaderImageView *header = [[ProfileSectionHeaderImageView alloc] initWithFrame:CGRectMake(0.f,
                                                                                                                0.f,
                                                                                                                320.,
                                                                                                                140.f)
                                                                                           withImage:[UIImage imageNamed:@"anotherCrop.jpg"]];
        header.frame = CGRectMake(0.f,0.f,header.headerImage.size.width,header.headerImage.size.height);
        [self.contentView addSubview:header];

        TitleOverlayView *overlay = [[TitleOverlayView alloc] initWithFrame:CGRectMake(120.f,
                                                                                       OVERLAY_PADDING,
                                                                                       [self overlayWidth],
                                                                                       0.f)
                                                                   andTitle:@"TAKE A SELFIE EVERY DAMN DAY"];

        CGRect overlayFrame = CGRectMake(header.frame.size.width - (overlay.frame.size.width + OVERLAY_PADDING),
                                         OVERLAY_PADDING,
                                         overlay.frame.size.width,
                                         overlay.frame.size.height);
        overlay.frame = overlayFrame;
        [header addSubview:overlay];

        ProfileSectionDateSeparatorView *sep = [[ProfileSectionDateSeparatorView alloc] initWithFrame:CGRectMake(0.f,
                                                                                                                 header.frame.size.height,
                                                                                                                 320.,
                                                                                                                 SEPARATOR_WIDTH)
                                                                                     andChallengeSpan:@"JUNE - JULY 2013"];
        [header addSubview:sep];
    }
    return self;
}

//- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithReuseIdentifier:sectionHeaderViewReuseIdentifier];
//    if (self) {
//        NSLog(@"cut a bitch");
//    }
//    return self;
//}

- (CGFloat)overlayWidth
{
    // fix to some percentage of the window bounds
    return [[UIScreen mainScreen] bounds].size.width*(PERCENT_WINDOW_BOUNDS);
}
@end
