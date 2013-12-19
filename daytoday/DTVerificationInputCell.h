//
//  DTVerificationInputCell.h
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTBaseCommentCell.h"
#import "Verification.h"

@class DTVerificationInputCell;
@protocol DTVerificationInputCellDelegate <NSObject>

@optional
- (void)cell:(DTVerificationInputCell *)cellView didTapSubmitButton:(UITextView *)textView;
@end

@interface DTVerificationInputCell : DTBaseCommentCell

@property (nonatomic,weak) id<DTVerificationInputCellDelegate> submitDelegate;

@property (nonatomic) DTVerificationType verificationType;
@property (nonatomic,strong) UIImageView *verificationTypeImage;
@property (nonatomic,strong) UILabel *verificationLabel;

@property (nonatomic,strong) UILabel *placeholderLabel;
@property (nonatomic,strong) UITextView *statusTextView;
@property (nonatomic,strong) UIButton *okButton;

- (void)setOrdinal:(NSNumber *)verificationOrdinal;

+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset;

#define STATUS_PLACE_HOLDER  @"Add a status message..."

#define verificationImageDim 25.f
#define statusTextViewHeight 80.f
#define okButtonHeight 36.f

@end
