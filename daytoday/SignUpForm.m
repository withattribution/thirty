//
//  SignUpForm.m
//  daytoday
//
//  Created by pasmo on 11/7/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "SignUpForm.h"
#import "UserEntryViewModel.h"

@interface SignUpForm () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *userNameField;

@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UserEntryViewModel *viewModel;

@end

#define EMAIL_FIELD_PLACEHOLDER NSLocalizedString(@"Email", @"Email as textfield placeholder")
#define PASS_FIELD_PLACEHOLDER NSLocalizedString(@"Password (min 6 characters)", @"Password Creation as textfield placeholder")
#define USERNAME_FIELD_PLACEHOLDER NSLocalizedString(@"Username", @"Username as textfield placeholder")

@implementation SignUpForm

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      _emailField = [[UITextField alloc] init];
      [_emailField setDelegate:self];
      [_emailField setTextColor:[UIColor whiteColor]];
      [_emailField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
      [_emailField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
      [_emailField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [_emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [_emailField setTextAlignment:NSTextAlignmentLeft];
      [_emailField setReturnKeyType:UIReturnKeyNext];
      [_emailField setKeyboardType:UIKeyboardTypeEmailAddress];
      [_emailField setPlaceholder:EMAIL_FIELD_PLACEHOLDER];
      [_emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_emailField sizeToFit];
      
      [_emailField becomeFirstResponder];
      
      [self addSubview:_emailField];
      
      _passwordField = [[UITextField alloc] init];
      [_passwordField setDelegate:self];
      [_passwordField setTextColor:[UIColor whiteColor]];
      [_passwordField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
      [_passwordField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
      [_passwordField setSecureTextEntry:YES];
      [_passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [_passwordField setTextAlignment:NSTextAlignmentLeft];
      [_passwordField setReturnKeyType:UIReturnKeyDefault];
      [_passwordField setKeyboardType:UIKeyboardTypeDefault];
      [_passwordField setPlaceholder:PASS_FIELD_PLACEHOLDER];
      [_passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_passwordField sizeToFit];
      
      [self addSubview:_passwordField];
      
      _userNameField = [[UITextField alloc] init];
      [_userNameField setDelegate:self];
      [_userNameField setTextColor:[UIColor whiteColor]];
      [_userNameField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
      [_userNameField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
      [_userNameField setAutocorrectionType:UITextAutocorrectionTypeNo];
      [_userNameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
      [_userNameField setTextAlignment:NSTextAlignmentLeft];
      [_userNameField setReturnKeyType:UIReturnKeyDefault];
      [_userNameField setKeyboardType:UIKeyboardTypeDefault];
      [_userNameField setPlaceholder:USERNAME_FIELD_PLACEHOLDER];
      [_userNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_userNameField sizeToFit];
      
      [self addSubview:_userNameField];
      
      NSString *signUpTitle = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
      _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_signupButton setTitle:signUpTitle forState:UIControlStateNormal];
      [_signupButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_signupButton setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];

      [_signupButton setEnabled:NO];
      [_signupButton addTarget:self action:@selector(attemptSignUp) forControlEvents:UIControlEventTouchUpInside];
      
      [_signupButton.layer setCornerRadius:2.5f];
      [_signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_signupButton];
      
      NSString *logInTitle = NSLocalizedString(@"Log In", @"Sign Up as a header or button field");
      _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_loginButton setTitle:logInTitle forState:UIControlStateNormal];
      [_loginButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_loginButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      
      [_loginButton addTarget:self.superview action:@selector(setStateForLogIn:) forControlEvents:UIControlEventTouchUpInside];
      
      [_loginButton.layer setCornerRadius:2.5f];

      [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:_loginButton];
      
      [self signalsForSignUp];

    }
    return self;
}

- (void)updateConstraints
{
  [super updateConstraints];
  
  [self addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:
    @"V:|[emailField(40)]-(5)-[passwordField(40)]-(5)-[userNameField(40)]-(20)-[signupButton(40)]-(5)-[loginButton(40)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"emailField": _emailField,
                                                                              @"passwordField": _passwordField,
                                                                              @"userNameField": _userNameField,
                                                                              @"signupButton": _signupButton,
                                                                              @"loginButton": _loginButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emailField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"emailField": _emailField}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[passwordField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"passwordField": _passwordField}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"userNameField": _userNameField}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[signupButton]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"signupButton": _signupButton,}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"loginButton": _loginButton}]];
}

- (void)toggleAllowSignUp
{
  [UIView animateWithDuration:.42f
                   animations:^{
                     if (self.signupButton.enabled)
                       [_signupButton setBackgroundColor:[UIColor colorWithRed:(34.f/255.f) green:(247.f/255.f) blue:(255.f/255.f) alpha:1.f]];
                     else
                       [_signupButton setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];
                   }
                   completion:^(BOOL finished){

                   }];
}


#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField.hasText && [textField isEqual:_emailField]) {
    if (!_passwordField.hasText) [_passwordField becomeFirstResponder];
    else if(!_userNameField.hasText) [_userNameField becomeFirstResponder];
    else [textField resignFirstResponder];

    return YES;
  }

  if (textField.hasText && [textField isEqual:_passwordField]) {
    if (!_userNameField.hasText) [_userNameField becomeFirstResponder];
    else if(!_emailField.hasText) [_emailField becomeFirstResponder];
    else [textField resignFirstResponder];

    return YES;
  }
  if (textField.hasText && [textField isEqual:_userNameField]) {
    if (!_emailField.hasText) [_emailField becomeFirstResponder];
    else if(!_passwordField.hasText) [_passwordField becomeFirstResponder];
    else [textField resignFirstResponder];

    return YES;
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if ( (_userNameField.hasText && _passwordField.hasText) ||
       (_userNameField.hasText && _emailField.hasText   ) ||
       (_passwordField.hasText && _emailField.hasText)  )
  {
    [textField setReturnKeyType:UIReturnKeyDone];
  }else {
    [textField setReturnKeyType:UIReturnKeyNext];
  }
  return YES;
}

#pragma mark - Signals and SignUp Methods

- (void)signalsForSignUp
{
  self.viewModel = [UserEntryViewModel new];
  
  RACSignal *emailValidSignal = [self.emailField.rac_textSignal
                                 map:^id(NSString *email){
                                   return @([self.viewModel isValidEmailAddress:email]);
                                 }];
  
  RACSignal *passwordValidSignal = [self.passwordField.rac_textSignal
                                    map:^id(NSString *pass){
                                      return @([self.viewModel isValidPassword:pass]);
                                    }];
  
  RACSignal *userNameValidSignal = [self.userNameField.rac_textSignal
                                    map:^id(NSString *name){
                                      return @([self.viewModel isValidUserName:name]);
                                    }];
  
  RAC(self.viewModel, emailCredential) = self.emailField.rac_textSignal;
  RAC(self.viewModel, passwordCredential) = self.passwordField.rac_textSignal;
  RAC(self.viewModel, usernameCredential) = self.userNameField.rac_textSignal;

  RACSignal *signUpActiveSignal =
  [RACSignal combineLatest:@[emailValidSignal, passwordValidSignal, userNameValidSignal]
                    reduce:^id(NSNumber *emailValid, NSNumber *passwordValid, NSNumber *userNameValid){
                      return @([emailValid boolValue] && [passwordValid boolValue] && [userNameValid boolValue]);
                    }];

  [signUpActiveSignal subscribeNext:^(NSNumber *signUpActive){
    self.signupButton.enabled = [signUpActive boolValue];
    [self toggleAllowSignUp];
  }];
}

- (void)attemptSignUp
{
  [DTCommonRequests signUpWithEmailCredential:self.viewModel.emailCredential
                                     password:self.viewModel.passwordCredential
                                         user:self.viewModel.usernameCredential];
   
}

@end