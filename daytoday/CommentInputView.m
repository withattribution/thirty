//
//  CommentInputView.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//


#import "CommentInputView.h"

@interface CommentInputView () <UITextViewDelegate>

@property (nonatomic,strong) UIButton *photoButton;
@property (nonatomic,strong) UIButton *sendComment;

@property (nonatomic,strong) UITextView *commentTextView;
@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic,assign) BOOL commentImageSet;

@end

#define COMMENT_FIELD_PLACEHOLDER  @"Add a comment"

@implementation CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_photoButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
      [_photoButton setImage:[UIImage imageNamed:@"takePhoto.png"] forState:UIControlStateNormal];
      [_photoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_photoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
      [_photoButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_photoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
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
      
      _sendComment = [UIButton buttonWithType:UIButtonTypeCustom];
      [_sendComment.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
      //      [_photoButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_sendComment setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [_sendComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
      [_sendComment setTitle:@"SEND" forState:UIControlStateNormal];
      [_sendComment setEnabled:([self.commentTextView hasText] || self.commentImageSet) ? YES : NO];
      [_sendComment addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
      [_sendComment setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_sendComment setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_sendComment];
      
      
      [self addSubview:_photoButton];
      
      [self setBackgroundColor:[UIColor darkGrayColor]];

      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      self.commentImageSet = NO;
    }
    return self;
}

- (void)sendComment:(UIButton *)sendButton
{
  if ([_delegate respondsToSelector:@selector(willHandleAttemptToAddComment:)])
    [_delegate willHandleAttemptToAddComment:self.commentTextView.text];
}

- (void)addPhoto:(UIButton *)aButton
{
  if([_delegate respondsToSelector:@selector(didSelectPhotoInput)])
     [_delegate didSelectPhotoInput];
}

- (void)placeImageThumbnailPreview:(UIImage *)previewImage
{
  if (previewImage) {
    [self.photoButton setImage:previewImage forState:UIControlStateNormal];
    self.commentImageSet = YES;
  }
  else {
    [self.photoButton setImage:[UIImage imageNamed:@"takePhoto.png"] forState:UIControlStateNormal];
  }
  [self.sendComment setEnabled:self.commentImageSet];
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
  [self.sendComment setEnabled:([self.commentTextView hasText] || self.commentImageSet) ? YES : NO];

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

#pragma mark - Constraint Based Layout

- (void)updateConstraints
{
  [super updateConstraints];
  
//  NSDictionary *metrics = @{@"textViewHeight":@(110)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[photoButton(50)]-(2)-[textView]-(2)-[sendComment(50)]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"sendComment": _sendComment,
                                                                         @"textView": _commentTextView,
                                                                         @"photoButton": _photoButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[textView(46)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"textView": _commentTextView}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[photoButton(46)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"photoButton": _photoButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[sendComment(46)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"sendComment": _sendComment}]];
  
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

@end