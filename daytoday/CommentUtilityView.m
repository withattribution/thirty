//
//  CommentUtilityView.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CommentUtilityView.h"

@interface CommentUtilityView ()

@property (nonatomic,strong) UIButton *cancelComment;

@end

@implementation CommentUtilityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      _cancelComment = [UIButton buttonWithType:UIButtonTypeCustom];
      [_cancelComment.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
      //      [_photoButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_cancelComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_cancelComment setTitle:@"CANCEL" forState:UIControlStateNormal];
      [_cancelComment addTarget:self action:@selector(cancelComment:) forControlEvents:UIControlEventTouchUpInside];
      [_cancelComment setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_cancelComment setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_cancelComment];
      
      [self setBackgroundColor:[UIColor colorWithWhite:.4f alpha:.9f]];
      
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

- (void)updateConstraints
{
  [super updateConstraints];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(2)-[cancelComment]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"cancelComment": _cancelComment}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[cancelComment(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"cancelComment": _cancelComment}]];
  
  
}

@end
