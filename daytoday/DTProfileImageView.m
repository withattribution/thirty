//
//  DTProfileImageView.m
//  daytoday
//
//  Created by pasmo on 12/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTProfileImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DTProfileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setBackgroundColor:[UIColor clearColor]];
      self.profileImageView = [[PFImageView alloc] init];
      self.profileImageView.layer.cornerRadius = 15;
//      self.profileImageView.layer.cornerRadius = self.frame.size.height/2.f;
//      self.profileImageView.layer.masksToBounds = YES;
      [self addSubview:self.profileImageView];

      self.profileButton  = [UIButton buttonWithType:UIButtonTypeCustom];
      [self addSubview:self.profileButton];
    }
    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.profileImageView.frame = CGRectMake( 1.0f, 0.0f, self.frame.size.width, self.frame.size.height);
  self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

- (void)setFile:(PFFile *)file {
  if (!file) {
    return;
  }
  
  self.profileImageView.image = [UIImage imageNamed:@"UserImagePlaceholder.png"];
  self.profileImageView.file = file;
  [self.profileImageView loadInBackground];
}
@end
