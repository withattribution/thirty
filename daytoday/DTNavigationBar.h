//
//  DTNavigationBar.h
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTProfileImageView.h"

@protocol DTNavigationBarDelegate <NSObject>

@optional

- (void)userDidTapUserProfileButton:(UIButton *)button user:(PFUser *)user;
- (void)userDidTapChallengeFeedButton:(UIButton *)button intent:(PFObject *)intent;

@end


@interface DTNavigationBar : UIView

@property (nonatomic,strong) PFUser *user;
@property (nonatomic,strong) DTProfileImageView *userProfileView;

@property (nonatomic,weak)   id<DTNavigationBarDelegate> delegate;

@property (nonatomic,strong) UILabel  *contentLabel;
@property (nonatomic,strong) UIView   *contentBacking;
@property (nonatomic,strong) UIButton *contentButton;

@property (nonatomic,strong) UIImageView *accessoryCaret;

@property (nonatomic) CGFloat barInsetWidth;

- (void)setUser:(PFUser *)aUser;
- (void)setContentText:(NSString *)contentString;
- (void)setInsetWidth:(CGFloat)insetWidth;

/*! Layout constants */
#define vertNavBorderSpacing 3.0f
#define vertNavElemSpacing 2.0f

#define horiNavBorderSpacing 8.0f
#define horiNavElemSpacing 18.0f

#define userProfileX horiNavBorderSpacing
#define userProfileY vertNavBorderSpacing
#define userProfileDim 35.0f

#define accessoryDimX 8.f
#define accessoryDimY 14.f

#define textBackingX horiNavBorderSpacing+horiNavElemSpacing+userProfileDim
#define textBackingY vertNavBorderSpacing
#define textBackingHeight userProfileDim

@end
