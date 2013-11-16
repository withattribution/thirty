//
//  CommentUtilityView.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CommentUtilityView.h"

@interface CommentUtilityView ()

@property (nonatomic,strong) UIButton *sendComment;
@property (nonatomic,strong) UIButton *cancelComment;

@end

@implementation CommentUtilityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      _cancelComment = [UIButton buttonWithType:UIButtonTypeCustom];
      [_cancelComment.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
      //      [_photoButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_cancelComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_cancelComment setTitle:@"CANCEL" forState:UIControlStateNormal];
      [_cancelComment addTarget:self action:@selector(cancelComment:) forControlEvents:UIControlEventTouchUpInside];
      [_cancelComment setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_cancelComment setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_cancelComment];

      _sendComment = [UIButton buttonWithType:UIButtonTypeCustom];
      [_sendComment.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0]];
      //      [_photoButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_sendComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_sendComment setTitle:@"COMMENT" forState:UIControlStateNormal];
      [_sendComment addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
      [_sendComment setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_sendComment setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_sendComment];
      
      [self setBackgroundColor:[UIColor darkGrayColor]];
      
      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (void)cancelComment:(UIButton *)cancelButton
{
  NSLog(@"cancel");
  if ([_delegate respondsToSelector:@selector(didCancelCommentAddition)]) {
    [_delegate didCancelCommentAddition];
  }
  
}

- (void)sendComment:(UIButton *)sendButton
{
  NSLog(@"send");
}

- (void)updateConstraints
{
  [super updateConstraints];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(2)-[cancelComment]-(200)-[sendComment]-(2)-|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"cancelComment": _cancelComment,@"sendComment": _sendComment}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[cancelComment(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"cancelComment": _cancelComment}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[sendComment(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"sendComment": _sendComment}]];
  
}

@end
