//
//  UserEntry.m
//  daytoday
//
//  Created by pasmo on 11/7/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "UserEntry.h"

@interface UserEntry ()

@property (nonatomic,strong) UIButton *signupButton;
@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *facebookLoginButton;

@end

@implementation UserEntry

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      NSString *signUpTitle = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
      _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_signupButton setTitle:signUpTitle forState:UIControlStateNormal];
      [_signupButton.titleLabel setTextColor:[UIColor whiteColor]];
  
      [_signupButton addTarget:self.superview action:@selector(displaySignUpForm:) forControlEvents:UIControlEventTouchUpInside];

      [_signupButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_signupButton.layer setCornerRadius:2.5f];


      [self addSubview:_signupButton];
      
      NSString *logInTitle = NSLocalizedString(@"Log In", @"Sign Up as a header or button field");
      _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_loginButton setTitle:logInTitle forState:UIControlStateNormal];
      [_loginButton.titleLabel setTextColor:[UIColor whiteColor]];
      [_loginButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [_loginButton addTarget:self action:@selector(displayLogin:) forControlEvents:UIControlEventTouchUpInside];
      [_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_loginButton.layer setCornerRadius:2.5f];


      [self addSubview:_loginButton];
      
      NSString *facebookTitle = NSLocalizedString(@"Login with Facebook", @"facebook login button");
      _facebookLoginButton  = [UIButton buttonWithType:UIButtonTypeCustom];
      [_facebookLoginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_facebookLoginButton setTitle:facebookTitle forState:UIControlStateNormal];
      [_facebookLoginButton setBackgroundColor:[UIColor colorWithRed:(34.f/255.f) green:(247.f/255.f) blue:(255.f/255.f) alpha:1.f]];
      [_facebookLoginButton addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
      [_facebookLoginButton.layer setCornerRadius:2.5f];


      [self addSubview:_facebookLoginButton];
      
    }
    return self;
}

- (void)updateConstraints
{
  [super updateConstraints];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[signupButton]-(20)-[loginButton(==signupButton)]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"signupButton": _signupButton,
                                                                         @"loginButton": _loginButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[signupButton]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"signupButton": _signupButton,
                                                                         @"loginButton": _loginButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loginButton(==signupButton)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"signupButton": _signupButton,
                                                                         @"loginButton": _loginButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[facebookLoginButton]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"facebookLoginButton": _facebookLoginButton}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loginButton]-(10)-[facebookLoginButton(==signupButton)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:nil
                                                                 views:@{@"facebookLoginButton": _facebookLoginButton,
                                                                         @"signupButton": _signupButton,
                                                                         @"loginButton": _loginButton}]];
}


@end
