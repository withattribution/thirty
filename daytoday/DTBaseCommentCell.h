//
//  DTBaseCommentCell.h
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTProfileImageView.h"

@class DTBaseCommentCell;
@protocol DTBaseCommentCellDelegate <NSObject>

@optional
- (void)cell:(DTBaseCommentCell *)cellView didTapUserButton:(PFUser *)aUser;
@end

@interface DTBaseCommentCell : UITableViewCell {
  NSUInteger horizontalTextSpace;
}

@property (nonatomic,weak) id<DTBaseCommentCellDelegate> delegate;

@property (nonatomic,strong) PFUser *user;

@property (nonatomic,strong) UIView *mainView;

@property (nonatomic,strong) DTProfileImageView *userImageView;
@property (nonatomic,strong) UIButton *nameButton;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *textBacking;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) PFImageView *contentImageView;

/*! The horizontal inset of the cell */
@property (nonatomic) CGFloat cellInsetWidth;

/*! Static Helper methods */
+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset;

/*! Setters for the cell's content */

- (void)setContentText:(NSString *)contentString;
- (void)setDate:(NSDate *)date;
- (void)setInsetWidth:(CGFloat)insetWidth;

/*! Layout constants */
#define vertBorderSpacing 2.0f
#define vertElemSpacing 8.0f

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

#define timeY nameY


@end
