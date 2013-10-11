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
@synthesize challengeLabel,sectionImageView;

//static CGFloat PERCENT_WINDOW_BOUNDS = 0.50f;
//static CGFloat OVERLAY_PADDING = 5.0f;
//static CGFloat SEPARATOR_WIDTH = 14.0f;

static CGFloat TEXT_PADDING = 3.0f;
static CGFloat TEXT_BACKING_HEIGHT = 20.f;
static CGFloat SECTION_IMAGE_HEIGHT = 140.f;
static CGFloat SECTION_IMAGE_WIDTH = 320.f;

//static NSString *sectionHeaderViewReuseIdentifier = @"sectionHeaderViewReuseIdentifier";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sectionImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"sectionImageHolder.jpg"]];
//        [userImage setPathToNetworkImage: @"http://daytoday-dev.s3.amazonaws.com/images/a0e2d3d7813b495181f56a7f528012a8.jpeg"
//                          forDisplaySize: CGSizeMake(PROFILE_SIZE, PROFILE_SIZE)
//                             contentMode: UIViewContentModeScaleAspectFill];
        
//        ProfileSectionHeaderImageView *header = [[ProfileSectionHeaderImageView alloc] initWithFrame:CGRectMake(0.f,
//                                                                                                                0.f,
//                                                                                                                320.,
//                                                                                                                140.f)
//                                                                                           withImage:[UIImage imageNamed:@"anotherCrop.jpg"]];
//        header.frame = CGRectMake(0.f,0.f,header.headerImage.size.width,header.headerImage.size.height);
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
        self.challengeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        self.challengeLabel.text = @"TEST LABEL";
        self.challengeLabel.numberOfLines = 1;
        self.challengeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.challengeLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.sectionImageView addSubview:self.challengeLabel];
    }
    return self;
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    NIDINFO(@"the intent: %@", self.intent);
//}

//- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier withIntent:(Intent *)i
//{
//    self = [super initWithReuseIdentifier:sectionHeaderViewReuseIdentifier];
//    if (self) {
////        NIDINFO(@"FIRST");
////        self.intent = i;
//    }
//    return self;
//}

/*************** OVER IT ***************/
//        TitleOverlayView *overlay = [[TitleOverlayView alloc] initWithFrame:CGRectMake(120.f,
//                                                                                       OVERLAY_PADDING,
//                                                                                       [self overlayWidth],
//                                                                                       0.f)
//                                                                   andTitle:@"TAKE A SELFIE EVERY DAMN DAY"];
//
//        CGRect overlayFrame = CGRectMake(header.frame.size.width - (overlay.frame.size.width + OVERLAY_PADDING),
//                                         OVERLAY_PADDING,
//                                         overlay.frame.size.width,
//                                         overlay.frame.size.height);
//        overlay.frame = overlayFrame;
//        [header addSubview:overlay];
//        ProfileSectionDateSeparatorView *sep = [[ProfileSectionDateSeparatorView alloc] initWithFrame:CGRectMake(0.f,
//                                                                                                                 header.frame.size.height,
//                                                                                                                 320.,
//                                                                                                                 SEPARATOR_WIDTH)
//                                                                                     andChallengeSpan:@"JUNE - JULY 2013"];
//        [header addSubview:sep];
/*************** OVER IT ***************/

//- (CGFloat)overlayWidth
//{
//    // fix to some percentage of the window bounds
//    return [[UIScreen mainScreen] bounds].size.width*(PERCENT_WINDOW_BOUNDS);
//}
@end
