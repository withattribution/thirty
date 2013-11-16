//
//  CommentInputView.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CommentInputView.h"

@interface CommentInputView () <UITextViewDelegate>

@property (nonatomic,strong) UITextView *commentTextView;
@property (nonatomic,strong) UILabel *placeholderLabel;
@property (nonatomic,strong) UIButton *photoButton;

@end

#define COMMENT_FIELD_PLACEHOLDER  @"Add a comment"

@implementation CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _commentTextView = [[UITextView alloc] init];
      [_commentTextView setDelegate:self];
      [_commentTextView setTextColor:[UIColor whiteColor]];
      [_commentTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18] ];
      [_commentTextView setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_commentTextView setScrollEnabled:YES];
      [_commentTextView setReturnKeyType:UIReturnKeyDefault];
      [_commentTextView setKeyboardType:UIKeyboardTypeDefault];
      [_commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_commentTextView];
      
      _placeholderLabel = [[UILabel alloc] init];
      [_placeholderLabel setTextColor:[UIColor colorWithWhite:.2f alpha:.4f]];
      [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
      [_placeholderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
      [_placeholderLabel setText:COMMENT_FIELD_PLACEHOLDER];
      [_placeholderLabel setNumberOfLines:1];
      [_placeholderLabel setTextAlignment:NSTextAlignmentLeft];
      [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_placeholderLabel sizeToFit];
      [self addSubview:_placeholderLabel];
      
      _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_photoButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
//      [_photoButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_photoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_photoButton setTitle:@"PHOTO" forState:UIControlStateNormal];
//      [_photoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
      [_photoButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_photoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_photoButton];
      
      [self setBackgroundColor:[UIColor darkGrayColor]];

      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (void)updateConstraints
{
  [super updateConstraints];
  
//  NSDictionary *metrics = @{@"textViewHeight":@(110)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]-(2)-[photoButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"textView": _commentTextView,@"photoButton": _photoButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[textView(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"textView": _commentTextView}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[photoButton(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"photoButton": _photoButton}]];
  
  // 5 point offset to simulate uitextview margins
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[placeHolder]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"placeHolder":_placeholderLabel}]];
  // 8 point offset to simulate uitextview margins
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[placeHolder]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"placeHolder":_placeholderLabel}]];
}

- (void)shouldBeFirstResponder
{
  if (_commentTextView && ![_commentTextView isFirstResponder]) {
    [_commentTextView becomeFirstResponder];
  }
}

- (void)shouldResignFirstResponder
{
  if (_commentTextView && [_commentTextView isFirstResponder]) {
    [_commentTextView resignFirstResponder];
  }
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
//  if ([_commentTextView hasText]) {
//    self.description = [NSString stringWithString:_commentTextView.text];
//  }

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
  
}

@end
