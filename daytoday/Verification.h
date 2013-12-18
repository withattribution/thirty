//
//  Verification.h
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTVerificationType) {
  DTVerificationTickMark = 0, //0
  DTVerificationCheckIn,      //1
  DTVerificationPhoto,        //2
  DTVerificationTimer         //3
};

@interface Verification : NSObject

+ (UIImage *)imageForType:(DTVerificationType)type;
+ (UIImage *)activityImageForType:(DTVerificationType)type;
+ (NSString *)stringForType:(DTVerificationType)type;
+ (NSString *)ordinalMessageForNumber:(NSNumber *)ordinal;
+ (NSArray *)verficationImages;

@end

