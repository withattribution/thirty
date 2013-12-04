//
//  Verification+UImage.h
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTVerificationType) {
  DTVerificationTickMark,
  DTVerificationCheckIn,
  DTVerificationPhoto,
  DTVerificationTimer
};

@interface Verification : NSObject

+ (UIImage *)imageForType:(DTVerificationType)type;
+ (NSString *)stringForType:(DTVerificationType)type;
+ (NSArray *)verficationImages;

@end
