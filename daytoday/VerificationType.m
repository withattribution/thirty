//
//  VerificationType.m
//  daytoday
//
//  Created by pasmo on 10/28/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "VerificationType.h"

@implementation VerificationType

+ (id)verficationWithType:(DTVerificationType)type
{
  VerificationType *vt = [[VerificationType alloc] initWithType:type];
  return vt;
}

- (id)initWithType:(DTVerificationType)type
{
  self = [super initWithFrame:CGRectZero];
  if (self) {
    self.displayImage = [self imageForType:type];
  }
  return self;
}

- (UIImage *)imageForType:(DTVerificationType)t
{
  UIImage *image = [UIImage imageNamed:@"tickMark.jpg"];
  switch (t) {
    case DTVerificationTickMark:
      image = [UIImage imageNamed:@"tickMark.jpg"];
      break;
    case DTVerificationCheckIn:
      image = [UIImage imageNamed:@"checkIn.jpg"];
      break;
    case DTVerificationPhoto:
      image = [UIImage imageNamed:@"photo.jpg"];
      break;
    case DTVerificationTimer:
      image = [UIImage imageNamed:@"timer.jpg"];
      break;
    default:
      break;
  }
  return image;
}

@end
