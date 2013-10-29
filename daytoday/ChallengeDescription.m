//
//  ChallengeDescription.m
//  daytoday
//
//  Created by pasmo on 10/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDescription.h"

@interface ChallengeDescription () {
  NSLayoutConstraint *descriptionTop;
}

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (nonatomic) NSInteger charCount;
@property (strong, nonatomic) UILabel *charCountLabel;

@property (copy) void (^completionBlock)();

@end

@implementation ChallengeDescription

#define DESCRIBE_PLACE_HOLDER  @"Describe the challenge"
CGFloat static INPUT_VIEW_HEIGHT = 35.f;
CGFloat static TEXT_PADDING = 5.f;
CGFloat static BUTTON_TEXT_ALIGN = 2.f;
NSInteger static MAX_CHARS = 140;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _textView = [[UITextView alloc] init];
      [_textView setDelegate:self];
      [_textView setTextColor:[UIColor whiteColor]];
      [_textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18] ];
      [_textView setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.4f]];
      [_textView setScrollEnabled:NO];
      [_textView setReturnKeyType:UIReturnKeyDefault];
      [_textView setKeyboardType:UIKeyboardTypeDefault];
      [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];

      [self addSubview:_textView];
      
      _charCount = MAX_CHARS;
      [_textView setInputAccessoryView:[self descriptionInputView]];

      _placeholderLabel = [[UILabel alloc] init];
      [_placeholderLabel setTextColor:[UIColor whiteColor]];
      [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
      [_placeholderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
      [_placeholderLabel setText:DESCRIBE_PLACE_HOLDER];
      [_placeholderLabel setNumberOfLines:1];
      [_placeholderLabel setTextAlignment:NSTextAlignmentLeft];
      [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_placeholderLabel sizeToFit];
      [self addSubview:_placeholderLabel];
      
      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

#pragma mark ChallengeDescription Methods

- (UIView *)descriptionInputView
{
  
  UIView *input = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                           0.f,
                                                           [[UIScreen mainScreen] bounds].size.width,
                                                           INPUT_VIEW_HEIGHT)];
  [input setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.6f]];

  UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [okButton setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60.f,
                                0.0f,
                                60.f,
                                INPUT_VIEW_HEIGHT)];
  [okButton setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:.4f]];
  [okButton addTarget:self action:@selector(shouldDismissTextView:) forControlEvents:UIControlEventTouchUpInside];
  [okButton setTitle:NSLocalizedString(@"OK", @"OK for button") forState:UIControlStateNormal];

  [input addSubview:okButton];
  
  CGRect countRect = [[NSString stringWithFormat:@"%d",_charCount] boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width/2.f,FLT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]}
                                                       context:nil];
  
  NSString *charactersText = ( _charCount == 1 ) ? NSLocalizedString(@"CHARACTER LEFT", @"charactersLeft-singular")
  : NSLocalizedString(@"CHARACTERS LEFT", @"charactersLeft-plural");
  
  CGRect charactersRect = [charactersText boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width/2.f,FLT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13]}
                                                    context:nil];
  
  UIView *viewToCenter = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                                  0.f,
                                                                  (4*TEXT_PADDING) + countRect.size.width + charactersRect.size.width,
                                                                  INPUT_VIEW_HEIGHT-BUTTON_TEXT_ALIGN)];
  
  UIView *underline = [[UIView alloc] initWithFrame:CGRectMake((2*TEXT_PADDING) + countRect.size.width,
                                                               25.f,
                                                               charactersRect.size.width,
                                                               1.5f)];
  [underline setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
  [viewToCenter addSubview:underline];
  
  UILabel *charsLabel = [[UILabel alloc] initWithFrame:CGRectMake((2*TEXT_PADDING) + countRect.size.width,
                                                                 underline.frame.origin.y - charactersRect.size.height,
                                                                 charactersRect.size.width,
                                                                 charactersRect.size.height)];
  charsLabel.textColor = [UIColor whiteColor];
  charsLabel.backgroundColor = [UIColor clearColor];
  charsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
  charsLabel.text = charactersText;
  charsLabel.numberOfLines = 1;
  charsLabel.textAlignment = NSTextAlignmentLeft;
  [viewToCenter addSubview:charsLabel];
  
  _charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_PADDING,
                                                              0.f,
                                                              countRect.size.width,
                                                              INPUT_VIEW_HEIGHT)];
  _charCountLabel.textColor = [UIColor whiteColor];
  _charCountLabel.backgroundColor = [UIColor clearColor];
  _charCountLabel.textAlignment = NSTextAlignmentRight;
  _charCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
  _charCountLabel.text = [NSString stringWithFormat:@"%d",_charCount];
  [viewToCenter addSubview:_charCountLabel];
  
  viewToCenter.center = CGPointMake(input.center.x, viewToCenter.center.y - BUTTON_TEXT_ALIGN);
  [input addSubview:viewToCenter];
  
  return input;
}

- (void)descriptionDidComplete:(void (^)())block
{
  self.completionBlock = [block copy];
}

- (void)shouldDismissTextView:(UIButton *)b
{
  //save stuff here
  
  if ([_textView hasText]) {
    self.description = [NSString stringWithString:_textView.text];
  }

  if ([_textView isFirstResponder]) {
    [_textView resignFirstResponder];
  }

  if (self.completionBlock) {
    self.completionBlock();
  }

}

- (void)animateIntoViewForHeight:(CGFloat)offset
{
  
  descriptionTop.constant = offset;

  [UIView animateWithDuration:.37f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.superview layoutIfNeeded];
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       [self shouldBeFirstResponder];
                     }
                   }];
}


- (void)shouldBeFirstResponder
{
  if (_textView && ![_textView isFirstResponder]) {
    [_textView becomeFirstResponder];
  }
}

- (void)updateConstraints
{
  [super updateConstraints];
  
  NSDictionary *metrics = @{@"textViewHeight":@(110)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textView": _textView}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(textViewHeight)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textView": _textView}]];
  // 5 point offset to simulate uitextview margins
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[placeHolder]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"placeHolder":_placeholderLabel}]];
  // 8 point offset to simulate uitextview margins
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[placeHolder]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"placeHolder":_placeholderLabel}]];
  
  [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.f
                                                              constant:0]];
  
  descriptionTop = [NSLayoutConstraint constraintWithItem:self
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.superview
                                                attribute:NSLayoutAttributeTop
                                               multiplier:1.f
                                                 constant:self.superview.frame.size.height];

  [self.superview addConstraint:descriptionTop];

}

#pragma mark UITextView Delegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
  if ([_textView hasText]) {
    self.description = [NSString stringWithString:_textView.text];
  }
  
  if (textView.text.length > 0) {
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       _placeholderLabel.alpha = 0.0f; //(textView.hasText) ? 0.f : 1.f;
                     }
                     completion:^(BOOL finished) {
                       if (finished) {
                       }
                     }];
  }else {
    _placeholderLabel.alpha = 1.f;
  }
  
  _charCount = [textView.text length];
  _charCountLabel.text = [NSString stringWithFormat:@"%d",(MAX_CHARS - _charCount)];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  
}
@end
