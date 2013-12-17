//
//  VerificationStatusInput.m
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "VerificationStatusInput.h"

@interface VerificationStatusInput () <UITextViewDelegate>

+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

@end

@implementation VerificationStatusInput

#define STATUS_PLACE_HOLDER  @"Add a status message..."

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {

    self.insetWidth = 5.f;
    horizontalTextSpace =  [VerificationStatusInput horizontalTextSpaceForInsetWidth:self.insetWidth];
    
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.mainView = [[UIView alloc] initWithFrame:self.frame];
    [self.mainView setBackgroundColor:[UIColor clearColor]];
    
    self.userImageView = [[DTProfileImageView alloc] init];
    [self.userImageView.layer setCornerRadius:userImageDim/2.f];
    [self.userImageView setBackgroundColor:[UIColor darkGrayColor]];
    [self.userImageView setOpaque:YES];
    [self.userImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.userImageView];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameButton setBackgroundColor:[UIColor clearColor]];
    [self.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.nameButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
    [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.nameButton setUserInteractionEnabled:NO];
    [self.mainView addSubview:self.nameButton];
    
    self.contentBacking = [[UIView alloc] init];
    [self.contentBacking setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
    [self.mainView addSubview:self.contentBacking];
    
    self.verificationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verificationTick.png"]];
    [self.verificationImageView setBackgroundColor:[UIColor clearColor]];
    [self.verificationImageView setOpaque:YES];
    [self.mainView addSubview:self.verificationImageView];
    
    self.contentLabel = [[UILabel alloc] init];
    [self.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.contentLabel setTextColor:[UIColor darkGrayColor]];
    [self.contentLabel setNumberOfLines:1];
    [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:self.contentLabel];
    
    self.contentImageView = [[PFImageView alloc] init];
    [self.contentImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentImageView setOpaque:YES];
    [self.mainView addSubview:self.contentImageView];
    
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

    [self addSubview:self.mainView];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self.mainView setFrame:CGRectMake(self.insetWidth,
                                     self.frame.origin.y,
                                     self.frame.size.width - (2*self.insetWidth),
                                     self.frame.size.height)];
  // Layout user image
  [self.userImageView setFrame:CGRectMake(userImageX, userImageY, userImageDim, userImageDim)];
  
  // Layout the name button
  CGRect nameRect = [@"username" boundingRectWithSize:CGSizeMake(nameMaxWidth,CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]}
                                              context:nil];
  [self.nameButton setFrame:CGRectMake(nameX, nameY, nameRect.size.width, nameRect.size.height)];
  
  [self.contentBacking setFrame:CGRectMake(self.insetWidth,
                                          self.userImageView.frame.origin.y + userImageDim*.80,
                                          self.mainView.frame.size.width - (2*self.insetWidth),
                                           vertBorderSpacing + verificationImageDim + vertElemSpacing + statusTextHeight + vertBorderSpacing +(4*vertElemSpacing))];
  
  
  [self.verificationImageView setFrame:CGRectMake(self.userImageView.center.x - verificationImageDim/2.f,
                                           self.userImageView.frame.origin.y + userImageDim + vertElemSpacing,
                                           verificationImageDim,
                                           verificationImageDim)];
  // Layout the contentText
  CGRect textContentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace,CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                                context:nil];
  CGFloat textContentY = vertBorderSpacing+userImageDim;
  
  if (self.contentImageView.image != nil)
  {
    textContentY += imageContentDim;
    [self.contentImageView setFrame:CGRectMake(0.f, vertBorderSpacing+(userImageDim*(.80f)), imageContentDim-(2*self.insetWidth), imageContentDim)];
  }
  
  [self.contentLabel setFrame:CGRectMake(userImageX+userImageDim+horiElemSpacing+horiElemSpacing,
                                         self.verificationImageView.center.y - textContentRect.size.height/2.f,
                                         textContentRect.size.width,
                                         textContentRect.size.height)];
  
  [self.statusTextView setFrame:CGRectMake(self.mainView.frame.origin.x + horiBorderSpacing,
                                           self.verificationImageView.frame.origin.y + verificationImageDim + vertElemSpacing,
                                           self.mainView.frame.size.width - (2*horiBorderSpacing) - (2*self.insetWidth),
                                           statusTextHeight)];
  
  [self.placeholderLabel setFrame:CGRectMake(self.mainView.frame.origin.x + (2*horiBorderSpacing),
                                             self.verificationImageView.frame.origin.y + verificationImageDim + (2*vertElemSpacing),
                                             self.mainView.frame.size.width - (2*horiBorderSpacing),
                                             textContentRect.size.height)];
  
  [self.okButton setFrame:CGRectMake(self.insetWidth,
                                     self.contentBacking.frame.origin.y+self.contentBacking.frame.size.height + (4*vertElemSpacing),
                                     self.mainView.frame.size.width-(2*self.insetWidth),
                                     okButtonHeight)];
  
  [self.mainView bringSubviewToFront:self.userImageView];
}

- (void)setUser:(PFUser *)aUser
{
  _user = aUser;
  // Set name button properties and avatar image
  //  [self.userImageView setFile:[_user objectForKey:kPAPUserProfilePicSmallKey]];
  [self.nameButton setTitle:@"username" forState:UIControlStateNormal];
  [self.nameButton setTitle:@"username" forState:UIControlStateHighlighted];
  
  // If user is set after the contentText, we reset the content to include padding
  if (self.contentLabel.text) {
    [self setContentText:self.contentLabel.text];
  }
  [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString
{
  [self.contentLabel setText:[contentString uppercaseString]];
  [self setNeedsDisplay];
}

- (void)setInsetWidth:(CGFloat)insetWidth {
  // Change the mainView's frame to be insetted by insetWidth and update the content text space
  _insetWidth = insetWidth;
  [self.mainView setFrame:CGRectMake(insetWidth, self.mainView.frame.origin.y, self.mainView.frame.size.width-2*insetWidth, self.mainView.frame.size.height)];
  horizontalTextSpace = [VerificationStatusInput horizontalTextSpaceForInsetWidth:insetWidth];
  [self setNeedsDisplay];
}

/* Static helper to obtain the  horizontal space left for name and content after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
  return ([[UIScreen mainScreen] bounds].size.width-(insetWidth*2)) - (horiBorderSpacing+verificationImageDim+horiElemSpacing+horiBorderSpacing);
}

#pragma VerificationStatusInput Delegate Methods

- (void)didTapOkButtonAction:(UIButton *)aButton
{
  
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
