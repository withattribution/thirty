//
//  DTSocialDashBoard.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTSocialDashBoard.h"

@interface DTSocialDashBoard ()

@property (nonatomic,strong) UIButton *heartButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *shareButton;

@end

@implementation DTSocialDashBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      _likeCount = [NSNumber numberWithInt:0];
      _commentCount = [NSNumber numberWithInt:0];
      
      _heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_heartButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
      [_heartButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_heartButton setImage:[UIImage imageNamed:@"heart-selected.png"] forState:UIControlStateSelected];
      [_heartButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      
      if([_likeCount intValue] == 0)
        [_heartButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

      [_heartButton setTitle:[self.likeCount stringValue] forState:UIControlStateNormal];
      [_heartButton setAdjustsImageWhenHighlighted:NO];
      [_heartButton setContentEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
      [_heartButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 20.f, 0.f, 5.f)];
      [_heartButton setTitleEdgeInsets:UIEdgeInsetsMake(-16.5f, -10.f, 1.f, -36.f)];
      [_heartButton addTarget:self action:@selector(heartSelected:) forControlEvents:UIControlEventTouchUpInside];
      [_heartButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_heartButton setTranslatesAutoresizingMaskIntoConstraints:NO];

      [self addSubview:_heartButton];
      
      _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_commentButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
      [_commentButton setImage:[UIImage imageNamed:@"comment-normal.png"]
                      forState:UIControlStateNormal];
      [_commentButton setImage:[UIImage imageNamed:@"comment-selected.png"]
                      forState:UIControlStateSelected];
      [_commentButton setImage:[UIImage imageNamed:@"comment-selected.png"]
                      forState:(UIControlStateSelected | UIControlStateHighlighted)];
      [_commentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      [_commentButton setTitle:@"47" forState:UIControlStateNormal];
      [_commentButton setAdjustsImageWhenHighlighted:NO];
      [_commentButton setContentEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
      [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 20.f, 0.f, 5.f)];
      [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(-16.5f, -10.f, 1.f, -36.f)];
      [_commentButton addTarget:self action:@selector(commentSelected:) forControlEvents:UIControlEventTouchUpInside];
      [_commentButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_commentButton];
      
      _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_shareButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
      [_shareButton.titleLabel setNumberOfLines:2];
      [_shareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//      [_shareButton setImage:[UIImage imageNamed:@"comment-normal.png"] forState:UIControlStateNormal];
      [_shareButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_shareButton setTitle:@"share    disabled" forState:UIControlStateNormal];
      [_shareButton setAdjustsImageWhenHighlighted:NO];
      [_shareButton addTarget:self action:@selector(shareSelected:) forControlEvents:UIControlEventTouchUpInside];
      [_shareButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_shareButton];
      
      [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (void)setLikeCount:(NSNumber *)likeCount
{
  if (![_likeCount isEqualToNumber:likeCount]) {
    _likeCount = likeCount;
    
    [self.heartButton setTitle:[_likeCount stringValue] forState:UIControlStateNormal];
  }
  if ([_likeCount intValue] > 0) {
    [_heartButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  }else {
    [_heartButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
}

- (void)setCommentCount:(NSNumber *)commentCount
{
  _commentCount = commentCount;
  [self.commentButton setTitle:[_commentCount stringValue] forState:(UIControlStateNormal | UIControlStateSelected)];
}

- (void)heartSelected:(UIButton *)likeButton
{
  NSLog(@"this is the heart state: %d",self.heartButton.state);
  if (self.heartButton.state == (UIControlStateHighlighted | UIControlStateSelected) ) {
    [self.heartButton setSelected:NO];
    
    if ([self.likeCount intValue] > 0) {
      self.likeCount = [NSNumber numberWithInt:[self.likeCount intValue] - 1];
    
      if ([_delegate respondsToSelector:@selector(didTapLikeButtonFromDTSocialDashBoard:shouldLike:)])
        [_delegate didTapLikeButtonFromDTSocialDashBoard:self shouldLike:NO];
    }
  }
  else {
    [self.heartButton setSelected:YES];
    [self.heartButton setHighlighted:NO];

    self.likeCount = [NSNumber numberWithInt:[self.likeCount intValue] + 1];
    
    if ([_delegate respondsToSelector:@selector(didTapLikeButtonFromDTSocialDashBoard:shouldLike:)])
      [_delegate didTapLikeButtonFromDTSocialDashBoard:self shouldLike:YES];
  }
}

- (void)commentSelected:(UIButton *)comment
{
//  NSLog(@"this is the comment state: %d",self.commentButton.state);
  
  if ([_delegate respondsToSelector:@selector(didSelectComments)])
    [_delegate didSelectComments];
  
  if (self.commentButton.state == UIControlStateHighlighted ) {
//    NSLog(@"i am selected now");
    [self.commentButton setSelected:YES];
  }
  
  //increment the count as well

}

- (void)shareSelected:(UIButton *)share
{
  NSLog(@"this is the share");
}

#pragma mark - Constraint Based Layout

- (void)updateConstraints
{
  [super updateConstraints];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[heart(105)]-(2)-[comment(105)]-(2)-[share(105)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"heart":_heartButton,
                                                                         @"comment":_commentButton,
                                                                         @"share":_shareButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[heart(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"heart":_heartButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[comment(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"comment":_commentButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(2)-[share(36)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"share":_shareButton}]];
}


@end