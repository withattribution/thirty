//
//  DTNavigationBar.m
//  daytoday
//
//  Created by pasmo on 12/16/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTNavigationBar.h"

@interface DTNavigationBar () {
  CGFloat contentBackingWidth;
}
@end

@implementation DTNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      CGRect paddedFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, userProfileDim + (2*vertNavBorderSpacing));
      [self setFrame:paddedFrame];
      
      self.barInsetWidth = 3.f;
      
      contentBackingWidth = [DTNavigationBar horizontalTextBackingWidth:self.barInsetWidth];
      
      self.opaque = YES;
      self.backgroundColor = [UIColor clearColor];

      self.userProfileView = [[DTProfileImageView alloc] init];
      [self.userProfileView.layer setCornerRadius:userProfileDim/2.f];
      [self.userProfileView setBackgroundColor:[UIColor darkGrayColor]];
      [self.userProfileView setOpaque:YES];
      [self.userProfileView.profileButton addTarget:self action:@selector(didTapUserProfileButton:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.userProfileView];
      
      self.contentBacking = [[UIView alloc] init];
      [self.contentBacking setBackgroundColor:[UIColor colorWithWhite:8.f alpha:.9f]];
      [self addSubview:self.contentBacking];
      
      self.contentLabel = [[UILabel alloc] init];
      [self.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
      [self.contentLabel setTextColor:[UIColor blackColor]];
      [self.contentLabel setNumberOfLines:2];
      [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
      [self.contentLabel setBackgroundColor:[UIColor clearColor]];
      [self.contentLabel setUserInteractionEnabled:NO];
      [self addSubview:self.contentLabel];
      
      self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.contentButton setBackgroundColor:[UIColor clearColor]];
      [self.contentButton addTarget:self action:@selector(didTapChallengeFeedButton:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.contentButton];
      
      self.accessoryCaret = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessoryCaret.png"]];
      [self.accessoryCaret setBackgroundColor:[UIColor clearColor]];
      [self.accessoryCaret setOpaque:YES];
      [self addSubview:self.accessoryCaret];
    }
    return self;
}

+ (CGFloat)horizontalTextBackingWidth:(CGFloat)insetWidth {
  return ([[UIScreen mainScreen] bounds].size.width-(insetWidth*2)) - (horiNavBorderSpacing+horiNavElemSpacing+userProfileDim);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self.userProfileView setFrame:CGRectMake(userProfileX, userProfileY, userProfileDim, userProfileDim)];
  [self.contentBacking setFrame:CGRectMake(textBackingX, textBackingY, contentBackingWidth, textBackingHeight)];
  [self.contentButton setFrame:CGRectMake(textBackingX, textBackingY, contentBackingWidth, textBackingHeight)];

  CGRect textContentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentBacking.frame.size.width - (2*horiNavBorderSpacing) - accessoryDimX,CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13]}
                                                                context:nil];
  
  [self.contentLabel setFrame:CGRectMake(self.contentBacking.frame.origin.x + horiNavBorderSpacing,
                                         (self.contentBacking.frame.size.height-textContentRect.size.height)/2.f + vertNavBorderSpacing,
                                         textContentRect.size.width,
                                         textContentRect.size.height)];
  
  [self bringSubviewToFront:self.contentLabel];
  
  [self.accessoryCaret setFrame:CGRectMake(self.contentBacking.frame.origin.x + self.contentBacking.frame.size.width - accessoryDimX - horiNavBorderSpacing,
                                           (self.contentBacking.frame.size.height-accessoryDimY)/2.f + vertNavBorderSpacing,
                                           accessoryDimX,
                                           accessoryDimY)];
}

- (void)setUser:(PFUser *)aUser
{
  //  [self.userImageView setFile:[_user objectForKey:kPAPUserProfilePicSmallKey]];
  [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString
{
  [self.contentLabel setText:contentString];
  [self setNeedsDisplay];
}

- (void)setInsetWidth:(CGFloat)insetWidth
{
  self.barInsetWidth = insetWidth;
  contentBackingWidth = [DTNavigationBar horizontalTextBackingWidth:insetWidth];
  [self setNeedsDisplay];
}

#pragma mark - DTNavigationBar Delegate Methods

- (void)didTapUserProfileButton:(UIButton *)aButton
{
  if ([_delegate respondsToSelector:@selector(userDidTapUserProfileButton:user:)]) {
    [_delegate userDidTapUserProfileButton:aButton user:self.user];
  }
}

- (void)didTapChallengeFeedButton:(UIButton *)aButton
{
  if ([_delegate respondsToSelector:@selector(userDidTapChallengeFeedButton:intent:)]) {
    [_delegate userDidTapChallengeFeedButton:aButton intent:[self.user objectForKey:kDTUserActiveIntent]];
  }
}

@end
