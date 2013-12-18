//
//  Verification.m
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Verification.h"

@implementation Verification

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

+ (UIImage *)activityImageForType:(DTVerificationType)type
{
  UIImage *image = [UIImage imageNamed:@"verificationTick.png"];
  switch (type) {
    case DTVerificationTickMark:
      image = [UIImage imageNamed:@"verificationTick.png"];
      break;
    case DTVerificationCheckIn:
      image = [UIImage imageNamed:@"verificationTick.png"];
      break;
    case DTVerificationPhoto:
      image = [UIImage imageNamed:@"verificationTick.png"];
      break;
    case DTVerificationTimer:
      image = [UIImage imageNamed:@"verificationTick.png"];
      break;
    default:
      break;
  }
  return image;
}

+ (NSString *)stringForType:(DTVerificationType)type
{
  NSString *name = @"UNDEFINED VERIFICATION TYPE";
  
  switch (type) {
    case DTVerificationTickMark:
      name = NSLocalizedString(@"Task", @"tick mark verification type");
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

+ (NSString *)ordinalMessageForNumber:(NSNumber *)ordinal
{
  NSString *ordinalString = @"UNDEFINED ORDINAL";
  switch ([ordinal intValue]) {
    case 1:
      ordinalString = NSLocalizedString(@"First", @"first ordinal string");
      break;
    case 2:
      ordinalString = NSLocalizedString(@"Second", @"second ordinal string");
      break;
    case 3:
      ordinalString = NSLocalizedString(@"Third", @"third ordinal string");
      break;
    case 4:
      ordinalString = NSLocalizedString(@"Fourth", @"fourth ordinal string");
      break;
    case 5:
      ordinalString = NSLocalizedString(@"Fifth", @"Fifth ordinal string");
      break;
    case 6:
      ordinalString = NSLocalizedString(@"Sixth", @"sixth ordinal string");
      break;
    case 7:
      ordinalString = NSLocalizedString(@"Seventh", @"seventh ordinal string");
      break;
    case 8:
      ordinalString = NSLocalizedString(@"Eighth", @"eighth ordinal string");
      break;
    default:
      break;
  }
  return ordinalString;
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
