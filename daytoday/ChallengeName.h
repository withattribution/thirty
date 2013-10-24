//
//  ChallengeName.h
//  daytoday
//
//  Created by pasmo on 10/23/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeName : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;

@property (strong, nonatomic) NSString *challengeName;
//add external methods to animate the view into editing mode and "resting" mode

@end
