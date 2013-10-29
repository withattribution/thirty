//
//  Verification+UImage.m
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Verification+UImage.h"

@implementation Verification (UImage)

+ (UIImage *)imageForType:(DTVerificationType)type
{
  UIImage *image = [UIImage imageNamed:@"tickMark.jpg"];
 
  switch (type) {
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

+ (NSString *)stringForType:(DTVerificationType)type
{
  NSString *name = @"UNDEFINED VERIFICATION TYPE"; //NOT FOR DISPLAY PURPOSES
  
  switch (type) {
    case DTVerificationTickMark:
      name = NSLocalizedString(@"Tick Mark", @"tick mark verification type");
      break;
    case DTVerificationCheckIn:
      name = NSLocalizedString(@"Check In", @"check in verification type");
      break;
    case DTVerificationPhoto:
      name = NSLocalizedString(@"Photo", @"photo verification type");
      break;
    case DTVerificationTimer:
      name = NSLocalizedString(@"Timer", @"timer verification type");
      break;
    default:
      break;
  }
  return name;
}

+ (NSArray *)verficationImages
{
  NSMutableArray *images = [NSMutableArray arrayWithObjects:
                            [UIImage imageNamed:@"tickMark.jpg"],
                            [UIImage imageNamed:@"checkIn.jpg"],
                            [UIImage imageNamed:@"photo.jpg"],
                            [UIImage imageNamed:@"timer.jpg"],
                            nil];
  return images;
}

@end
