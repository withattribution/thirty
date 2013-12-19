//
//  DTVerificationInputCell.m
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTVerificationInputCell.h"

@interface DTVerificationInputCell () <UITextViewDelegate>
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;
@end

@implementation DTVerificationInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.cellInsetWidth = 0;
    horizontalTextSpace =  [DTVerificationInputCell horizontalTextSpaceForInsetWidth:self.cellInsetWidth];
    
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self.userImageView.profileButton setUserInteractionEnabled:NO];
    [self.nameButton setUserInteractionEnabled:NO];

    self.verificationTypeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verificationTick.png"]];
    [self.verificationTypeImage setBackgroundColor:[UIColor clearColor]];
    [self.verificationTypeImage setOpaque:YES];
    [self.mainView addSubview:self.verificationTypeImage];
    
    self.verificationLabel = [[UILabel alloc] init];
    [self.verificationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.verificationLabel setTextColor:[UIColor darkGrayColor]];
    [self.verificationLabel setNumberOfLines:1];
    [self.verificationLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.verificationLabel setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:self.verificationLabel];
    
    self.statusTextView = [[UITextView alloc] init];
    [self.statusTextView setDelegate:self];
    [self.statusTextView setTextColor:[UIColor blackColor]];
    [self.statusTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:15] ];
    [self.statusTextView setBackgroundColor:[UIColor clearColor]];
    [self.statusTextView setScrollEnabled:NO];
    [self.statusTextView setReturnKeyType:UIReturnKeyDefault];
    [self.statusTextView setKeyboardType:UIKeyboardTypeDefault];
    [self.mainView addSubview:self.statusTextView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    [self.placeholderLabel setTextColor:[UIColor colorWithWhite:.2f alpha:.4f]];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeholderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.placeholderLabel setText:STATUS_PLACE_HOLDER];
    [self.placeholderLabel setNumberOfLines:1];
    [self.placeholderLabel setTextAlignment:NSTextAlignmentLeft];
    [self.placeholderLabel sizeToFit];
    [self.mainView addSubview:self.placeholderLabel];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.okButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
    [self.okButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.okButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.okButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.okButton setTitle:@"OK" forState:UIControlStateHighlighted];
    [self.okButton addTarget:self action:@selector(didTapOkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.okButton];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGFloat textBackingY = self.userImageView.frame.origin.y+userImageDim*.80;
  
  if (self.contentImageView.image != nil)
  {
    textBackingY += imageContentDim+vertElemSpacing;
    [self.contentImageView setFrame:CGRectMake(0.f,
                                               self.userImageView.frame.origin.y+userImageDim*.80,
                                               imageContentDim-(2*self.cellInsetWidth),
                                               imageContentDim)];
  }
  CGRect verificationTextRect = [self.verificationLabel.text boundingRectWithSize:CGSizeMake(self.mainView.frame.size.width-(2*textContentX),CGFLOAT_MAX)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                                          context:nil];
  [self.textBacking setFrame:CGRectMake(0.f,
                                        textBackingY,
                                        self.mainView.frame.size.width,
                                        (2*vertBorderSpacing)+verificationImageDim+statusTextHeight+(3*vertElemSpacing))];
  [self.verificationTypeImage setFrame:CGRectMake(self.userImageView.center.x-verificationImageDim/2.f,
                                                  textBackingY+vertBorderSpacing+vertElemSpacing,
                                                  verificationImageDim,
                                                  verificationImageDim)];
  [self.verificationLabel setFrame:CGRectMake(nameX,
                                              textBackingY+vertBorderSpacing+vertElemSpacing+(verificationImageDim-verificationTextRect.size.height)/2.f,
                                              verificationTextRect.size.width,
                                              verificationTextRect.size.height)];
  [self.statusTextView setFrame:CGRectMake(textContentX,
                                           textBackingY+vertBorderSpacing+verificationImageDim+(2*vertElemSpacing),
                                           self.mainView.frame.size.width - (2*textContentX),
                                           statusTextViewHeight)];
  [self.placeholderLabel setFrame:CGRectMake(self.statusTextView.frame.origin.x+textContentX,
                                             self.statusTextView.frame.origin.y+vertElemSpacing,
                                             self.statusTextView.frame.size.width,
                                             verificationTextRect.size.height)];
  [self.okButton setFrame:CGRectMake(0.f,
                                     self.textBacking.frame.origin.y+self.textBacking.frame.size.height+vertElemSpacing,
                                     self.mainView.frame.size.width,
                                     okButtonHeight)];
  [self.mainView bringSubviewToFront:self.userImageView];
}

#pragma Static Helper Methods
/* Static helper to obtain the  horizontal space left for time after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth
{
  return [[self superclass] horizontalTextSpaceForInsetWidth:insetWidth];
}

+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset
{
  return [[self superclass] heightForCellTextContent:textContent hasImageContent:imageContent cellInsetWidth:cellInset]+(2*vertElemSpacing)+verificationImageDim+statusTextViewHeight+okButtonHeight;
}

#pragma mark Setter Methods

- (void)setOrdinal:(NSNumber *)verificationOrdinal
{
  [self.verificationLabel setText:[[NSString stringWithFormat:@"%@ %@ OF THE DAY",
                                    [Verification ordinalMessageForNumber:verificationOrdinal],
                                    [Verification stringForType:(DTVerificationType)0]] uppercaseString]];
  [self setNeedsDisplay];
}

- (void)setVerificationType:(DTVerificationType)verificationType
{
  [self.verificationTypeImage setImage:[Verification activityImageForType:verificationType]];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth
{
  [super setCellInsetWidth:insetWidth];
  // Change the mainView's frame to be insetted by insetWidth and update the content text space
  horizontalTextSpace = [DTVerificationInputCell horizontalTextSpaceForInsetWidth:insetWidth];
  [self setNeedsDisplay];
}

#pragma VerificationStatusInput Delegate Methods

- (void)didTapOkButtonAction:(UIButton *)aButton
{
  if([_submitDelegate respondsToSelector:@selector(cell:didTapSubmitButton:)]){
    [_submitDelegate cell:self didTapSubmitButton:self.statusTextView];
  }
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
  if (textView.text.length > 0) {
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       self.placeholderLabel.alpha = 0.0f; //(textView.hasText) ? 0.f : 1.f;
                     }
                     completion:^(BOOL finished) {
                       if (finished) {
                       }
                     }];
  }else {
    self.placeholderLabel.alpha = 1.f;
  }
}

@end
