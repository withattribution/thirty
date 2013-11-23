//
//  Verification+UImage.h
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Verification.h"

typedef NS_ENUM(NSInteger, DTVerificationType) {
  DTVerificationTickMark,
  DTVerificationCheckIn,
  DTVerificationPhoto,
  DTVerificationTimer
};

@interface Verification (UImage)

+ (UIImage *)imageForType:(DTVerificationType)type;
+ (NSString *)stringForType:(DTVerificationType)type;
+ (NSArray *)verficationImages;

@end
