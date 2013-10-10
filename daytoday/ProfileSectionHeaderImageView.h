//
//  ProfileSectionHeaderImageView.h
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSectionHeaderImageView : UIView

@property (nonatomic,strong) UIImage *headerImage;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)headerImage;

@end
