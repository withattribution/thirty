//
//  VerificationType.h
//  daytoday
//
//  Created by pasmo on 10/28/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

typedef NS_ENUM(NSInteger, DTVerificationType) {
  DTVerificationTickMark,
  DTVerificationCheckIn,
  DTVerificationPhoto,
  DTVerificationTimer
};

#import <UIKit/UIKit.h>

@interface VerificationType : UIView

+ (id)verficationWithType:(DTVerificationType)type;
- (id)initWithType:(DTVerificationType)type;

@property (nonatomic,retain) UIImage *displayImage;

@end
