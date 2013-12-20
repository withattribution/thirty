//
//  DTGlobalNavigation.m
//  daytoday
//
//  Created by pasmo on 12/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTGlobalNavigation.h"

@interface DTGlobalNavigation ()

@property (nonatomic) DTGlobalNavType globalNavigationType;
@end

@implementation DTGlobalNavigation

+ (id)globalNavigationWithType:(DTGlobalNavType)type
{
  CGRect frame = CGRectMake(0.f,[[UIScreen mainScreen] bounds].size.height-dtGlobalNavHeight,[[UIScreen mainScreen] bounds].size.width,dtGlobalNavHeight);
  return [[self alloc] initWithFrame:frame type:type];
}

- (id)initWithFrame:(CGRect)frame type:(DTGlobalNavType)type
{
    self = [super initWithFrame:frame];
    if (self) {
      self.insetWidth = 0.f;
      self.globalNavigationType = type;
      
      self.opaque = YES;
      self.backgroundColor = [UIColor clearColor];

      self.mainView = [[UIView alloc] initWithFrame:frame];
      [self.mainView setBackgroundColor:[UIColor clearColor]];

      self.globalNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.globalNavButton setTag:DTGlobalButtonTypeGlobal];
      [self.globalNavButton setBackgroundColor:[UIColor clearColor]];
      [self.globalNavButton setImage:[UIImage imageNamed:@"globalNavButton.png"] forState:UIControlStateNormal];
      [self.globalNavButton setImage:[UIImage imageNamed:@"globalNavButton.png"] forState:UIControlStateSelected];
      [self.globalNavButton addTarget:self action:@selector(didTapGlobalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.globalNavButton];

      self.fomoButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.fomoButton setTag:DTGlobalButtonTypeFomo];
      [self.fomoButton setTitle:([[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] != nil) ? @"save": @"join" forState:UIControlStateNormal];
      [self.fomoButton setTitle:([[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] != nil) ? @"save": @"join" forState:UIControlStateHighlighted];
      [self.fomoButton setBackgroundColor:[UIColor colorWithWhite:0.85f alpha:1.f]];
      [self.fomoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [self.fomoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
      [self.fomoButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
      [self.fomoButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
      [self.fomoButton addTarget:self action:@selector(didTapGlobalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.fomoButton];

      self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.commentButton setTag:DTGlobalButtonTypeComment];
      [self.commentButton setBackgroundColor:[UIColor clearColor]];
      [self.commentButton setImage:[UIImage imageNamed:@"globalCommentButton.png"] forState:UIControlStateNormal];
      [self.commentButton setImage:[UIImage imageNamed:@"globalCommentButton.png"] forState:UIControlStateSelected];
      [self.commentButton addTarget:self action:@selector(didTapGlobalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.commentButton];

      self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.shareButton setTag:DTGlobalButtonTypeShare];
      [self.shareButton setBackgroundColor:[UIColor clearColor]];
      [self.shareButton setImage:[UIImage imageNamed:@"globalShareButton.png"] forState:UIControlStateNormal];
      [self.shareButton setImage:[UIImage imageNamed:@"globalShareButton.png"] forState:UIControlStateSelected];
      [self.shareButton addTarget:self action:@selector(didTapGlobalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.shareButton];

      self.heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.heartButton setTag:DTGlobalButtonTypeHeart];
      [self.heartButton setBackgroundColor:[UIColor clearColor]];
      [self.heartButton setImage:[UIImage imageNamed:@"globalLikeButton.png"] forState:UIControlStateNormal];
      [self.heartButton setImage:[UIImage imageNamed:@"globalLikeButtonSelected.png"] forState:UIControlStateSelected];
      [self.heartButton setImage:[UIImage imageNamed:@"globalLikeButtonSelected.png"] forState:UIControlStateHighlighted];
      [self.heartButton addTarget:self action:@selector(didTapGlobalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.heartButton];

      [self addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  [self.mainView setFrame:CGRectMake(self.insetWidth,0.f,self.frame.size.width-(2*self.insetWidth),dtGlobalNavHeight)];

  CGFloat mainViewWidth = self.mainView.frame.size.width;
  
  [self.globalNavButton setFrame:CGRectMake(0.f,dtGlobalButtonY,dtGlobalButtonWidth,dtGlobalButtonHeight)];
  if(self.globalNavigationType == DTGlobalNavTypeSocial)
  {
    [self.fomoButton setFrame:CGRectMake(mainViewWidth-(3*dtGlobalButtonWidth+dtFomoButtonWidth+(3*dtHoriElement)),dtGlobalButtonY+3,dtFomoButtonWidth,dtGlobalButtonWidth)];
    [self.commentButton setFrame:CGRectMake(mainViewWidth-(3*dtGlobalButtonWidth+(2*dtHoriElement)),dtGlobalButtonY,dtGlobalButtonWidth,dtGlobalButtonHeight)];
    [self.shareButton setFrame:CGRectMake(mainViewWidth-(2*dtGlobalButtonWidth+dtHoriElement),dtGlobalButtonY,dtGlobalButtonWidth,dtGlobalButtonHeight)];
    [self.heartButton setFrame:CGRectMake(mainViewWidth-dtGlobalButtonWidth,dtGlobalButtonY,dtGlobalButtonWidth,dtGlobalButtonHeight)];
  }
}


#pragma mark Setters

- (void)setInsetWidth:(CGFloat)insetWidth
{
  _insetWidth = insetWidth;
  [self.mainView setFrame:CGRectMake(insetWidth, 0.f, self.frame.size.width-(2*insetWidth), dtGlobalNavHeight)];
}

#pragma mark Delegate Methods

- (void)didTapGlobalButtonAction:(UIButton *)aButton
{
  
  if([_delegate respondsToSelector:@selector(userDidTapGlobalNavigationButtonType:)]){
    [_delegate userDidTapGlobalNavigationButtonType:(DTGlobalButtonType)aButton.tag];
  }
}

@end
