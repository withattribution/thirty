//
//  SignUpForm.h
//  daytoday
//
//  Created by pasmo on 11/7/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpForm : UIView

@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *email;

@end
