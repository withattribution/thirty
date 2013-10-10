//
//  ProfileSectionHeaderImageView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "ProfileSectionHeaderImageView.h"
#import "UIImage+DT.h"

@implementation ProfileSectionHeaderImageView

static CGFloat CROP_RATIO = 3.75f;

@synthesize headerImage;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)hImage
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize toSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
        self.headerImage = [hImage resizeToSize:toSize thenCropWithRect:[self rectForHeaderImage:toSize]];
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:self.headerImage];
//        headerImageView.frame = CGRectMake(0.0, 0.0, self.headerImage.size.width, 120);
        [self addSubview:headerImageView];
    }
    return self;
}

- (CGRect)rectForHeaderImage:(CGSize)imageSize
{
    return CGRectMake(0.0f,
                      (imageSize.height/CROP_RATIO)*1.6,
                      imageSize.width,
                      imageSize.height/CROP_RATIO);
}

@end
