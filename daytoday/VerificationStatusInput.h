//
//  VerificationStatusInput.h
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTProfileImageView.h"

@class VerificationStatusInput;
@protocol VerificationStatusInputDelegate <NSObject>

@optional
- (void)statusInput:(VerificationStatusInput *)view didTapOkButton:(UIButton *)aButton textView:(UITextView *)textView;
@end

@interface VerificationStatusInput : UIView {
  NSUInteger horizontalTextSpace;
}

@property (nonatomic,weak) id<VerificationStatusInputDelegate> delegate;

@property (nonatomic,strong) PFUser *user;
@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) DTProfileImageView *userImageView;

@property (nonatomic,strong) UIButton *nameButton;
@property (nonatomic,strong) UIView *contentBacking;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *verificationImageView;

@property (nonatomic,strong) PFImageView *contentImageView;

@property (nonatomic,strong) UITextView *statusTextView;
@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic,strong) UIButton *okButton;


/*! The horizontal inset of the cell */
@property (nonatomic) CGFloat insetWidth;

/*! Setters for the cell's content */
- (void)setContentText:(NSString *)contentString;
- (void)setInsetWidth:(CGFloat)insetWidth;

/*! Layout constants */
#define vertBorderSpacing 2.0f
#define vertElemSpacing 2.0f

#define horiBorderSpacing 8.0f
#define horiBorderSpacingBottom 9.0f
#define horiElemSpacing 5.0f

#define vertTextBorderSpacing 10.0f

#define userImageX horiBorderSpacing
#define userImageY vertBorderSpacing
#define userImageDim 35.0f

#define textContentX horiBorderSpacing
//#define textContentY vertBorderSpacing+userImageDim+(4*vertElemSpacing)

#define imageContentX horiBorderSpacing
#define imageContentY vertBorderSpacing+userImageDim+(4*vertElemSpacing)
#define imageContentDim 320.f

#define nameX userImageX+userImageDim+horiElemSpacing+horiElemSpacing
#define nameY vertTextBorderSpacing
#define nameMaxWidth 200.0f

#define verificationImageDim 25.f
#define statusTextHeight 80.f

#define okButtonHeight 36.f
@end
