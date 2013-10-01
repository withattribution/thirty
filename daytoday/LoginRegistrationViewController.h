//
//  LoginRegistrationViewController.h
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2ViewController.h"

@interface LoginRegistrationViewController : D2ViewController
{
    UITextField *emailField;
    UITextField *passwordField;
    UIButton *loginButton;
    UIButton *signupButton;
    UIButton *switchButton;
    UILabel *usernameLabel;
    UILabel *passwordLabel;
    BOOL isLogin;
    
}
@end
