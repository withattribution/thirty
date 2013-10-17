//
//  LoginRegistrationViewController.h
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2ViewController.h"
#import "UserRequest.h"
#import "AuthenticationRequest.h"

@interface LoginRegistrationViewController : D2ViewController <AuthenticationRequestDelegate,UserRequestDelegate, UIAlertViewDelegate>
{
    UITextField *emailField;
    UITextField *passwordField;
    UIButton *loginButton;
    UIButton *signupButton;
    UIButton *switchButton;
    UIButton *facebookLoginButton;
    UILabel *usernameLabel;
    UILabel *passwordLabel;
    BOOL isLogin;
    
    UserRequest *userRequest;
    AuthenticationRequest *authenticationRequest;
    

    
}
@end
