//
//  ChallengeName.h
//  daytoday
//
//  Created by pasmo on 10/23/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeName : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (strong, nonatomic) NSString *challengeName;


//TODO make methods to change this view from a disabled looking color scheme to a enabled look one 

@end
