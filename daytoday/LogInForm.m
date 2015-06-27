//
//  LogInForm.m
//  daytoday
//
//  Created by pasmo on 11/7/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "LogInForm.h"
#import "UserEntryViewModel.h"

@interface LogInForm () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgotPassButton;

@property (nonatomic, strong) UserEntryViewModel *viewModel;

@end

#define USERNAME_FIELD_PLACEHOLDER NSLocalizedString(@"Email or Username", @"Login as textfield placeholder")
#define PASSWORD_FIELD_PLACEHOLDER NSLocalizedString(@"Password", @"Password as textfield placeholder")

@implementation LogInForm

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _userNameField = [[UITextField alloc] init];
      [_userNameField setDelegate:self];
      [_userNameField setTextColor:[UIColor whiteColor]];
      [_userNameField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
      [_userNameField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
      [_userNameField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [_userNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [_userNameField setTextAlignment:NSTextAlignmentLeft];
      [_userNameField setReturnKeyType:UIReturnKeyNext];
      [_userNameField setKeyboardType:UIKeyboardTypeDefault];
      [_userNameField setPlaceholder:USERNAME_FIELD_PLACEHOLDER];
      [_userNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_userNameField sizeToFit];

      [_userNameField becomeFirstResponder];

      [self addSubview:_userNameField];

      _passwordField = [[UITextField alloc] init];
      [_passwordField setDelegate:self];
      [_passwordField setTextColor:[UIColor whiteColor]];
      [_passwordField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
      [_passwordField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
      [_passwordField setSecureTextEntry:YES];
      [_passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [_passwordField setTextAlignment:NSTextAlignmentLeft];
//      [_passwordField setReturnKeyType:UIReturnKeyDefault];
//      [_passwordField setKeyboardType:UIKeyboardTypeDefault];
      [_passwordField setPlaceholder:PASSWORD_FIELD_PLACEHOLDER];
      [_passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_passwordField sizeToFit];

      [self addSubview:_passwordField];

      NSString *logInTitle = NSLocalizedString(@"Log In", @"Sign Up as a header or button field");
      _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_loginButton setTitle:logInTitle forState:UIControlStateNormal];
      [_loginButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_loginButton setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];
      
      [_loginButton addTarget:self action:@selector(attemptLogIn) forControlEvents:UIControlEventTouchUpInside];
      [_signupButton setEnabled:NO];

      [_loginButton.layer setCornerRadius:2.5f];
      [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_loginButton];

      NSString *forgotPassTitle = NSLocalizedString(@"Forgot Password?", @"Forgot Password as a button field");
      _forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_forgotPassButton setTitle:forgotPassTitle forState:UIControlStateNormal];
      [_forgotPassButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_forgotPassButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      //      [_signupButton addTarget:self.superview action:@selector(displaySignUp:) forControlEvents:UIControlEventTouchUpInside];
      [_forgotPassButton.layer setCornerRadius:2.5f];

      [_forgotPassButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_forgotPassButton];

      NSString *signUpTitle = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
      _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_signupButton setTitle:signUpTitle forState:UIControlStateNormal];
      [_signupButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_signupButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];

      [_signupButton addTarget:self.superview action:@selector(setStateForSignUp:) forControlEvents:UIControlEventTouchUpInside];

      [_signupButton.layer setCornerRadius:2.5f];

      [_signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_signupButton];
      
      [self signalsForLogin];
    }
    return self;
}

- (void) updateConstraints
{
  [super updateConstraints];

  [self addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:
    @"V:|[userNameField(40)]-(5)-[passwordField(40)]-(20)-[loginButton(40)]-(5)-[forgotPassButton(40)]-(5)-[signupButton(40)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"userNameField": _userNameField,
                                                                         @"passwordField": _passwordField,
                                                                         @"loginButton": _loginButton,
                                                                         @"forgotPassButton": _forgotPassButton,
                                                                         @"signupButton": _signupButton}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"userNameField": _userNameField}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[passwordField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"passwordField": _passwordField}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"loginButton": _loginButton}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[forgotPassButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"forgotPassButton": _forgotPassButton,}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[signupButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"signupButton": _signupButton,}]];
}

- (void)toggleAllowLogin
{
  [UIView animateWithDuration:.42f
                   animations:^{
                     if (_loginButton.enabled)
                       [_loginButton setBackgroundColor:[UIColor colorWithRed:(34.f/255.f) green:(247.f/255.f) blue:(255.f/255.f) alpha:1.f]];
                     else
                       [_loginButton setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];
                   }];
}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField.hasText && [textField isEqual:_userNameField]) {
    if(!_passwordField.hasText) [_passwordField becomeFirstResponder];
    else [textField resignFirstResponder];

    return YES;
  }
  
  if (textField.hasText && [textField isEqual:_passwordField]) {
    if (!_userNameField.hasText) [_userNameField becomeFirstResponder];
    else [textField resignFirstResponder];

    return YES;
  }

  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if ( _userNameField.hasText || _passwordField.hasText )
  {
    [textField setReturnKeyType:UIReturnKeyDone];
  }else {
    [textField setReturnKeyType:UIReturnKeyNext];
  }
  return YES;
}

#pragma mark - Signals and Login Methods

- (void)signalsForLogin
{
  self.viewModel = [UserEntryViewModel new];
  
  RACSignal *userNameValidSignal = [self.userNameField.rac_textSignal
                                    map:^id(NSString *name){
                                      return @([self.viewModel isValidUserName:name]);
                                    }];
  
  RACSignal *passwordValidSignal = [self.passwordField.rac_textSignal
                                    map:^id(NSString *pass){
                                      return @([self.viewModel isValidPassword:pass]);
                                    }];
  
  RAC(self.viewModel, usernameCredential) = self.userNameField.rac_textSignal;
  RAC(self.viewModel, passwordCredential) = self.passwordField.rac_textSignal;
  
  RACSignal *loginActiveSignal =
  [RACSignal combineLatest:@[userNameValidSignal, passwordValidSignal]
                    reduce:^id(NSNumber *userNameValid, NSNumber *passwordValid){
                      return @([userNameValid boolValue] && [passwordValid boolValue]);
                    }];
  
  [loginActiveSignal subscribeNext:^(NSNumber *loginActive){
    self.loginButton.enabled = [loginActive boolValue];
    [self toggleAllowLogin];
  }];
}

- (void)attemptLogIn
{
  [DTCommonRequests logInWithUserCredential:self.viewModel.usernameCredential
                                   password:self.viewModel.passwordCredential];
}

@end
