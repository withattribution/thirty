//
//  LoginRegistrationViewController.m
//  daytoday
//
//  Created by Alberto Tafoya on 10/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "LoginRegistrationViewController.h"

#import "SignUpForm.h"
#import "UserEntry.h"
#import "LogInForm.h"

@interface LoginRegistrationViewController () <UIAlertViewDelegate>
{
  BOOL _isLogin;
  UILabel *_titleLabel;
}

@property (nonatomic,strong) NSMutableDictionary *credentialsDictionary;

- (void)signupOrLogin:(id)sender;

- (void)prepareCredentialsDictionary;
- (BOOL)hasValidCredentialsForState;

- (void)addObserversForState;
- (void)removeObserversForState;

- (void)constraintsForForm:(UIView *)form;
- (CGSize)sizeForTitleAnimation;
- (void)animateToForm;

@end

@implementation LoginRegistrationViewController {
  UserEntry *_userEntry;
  SignUpForm *_signUpForm;
  LogInForm  *_logInForm;
}

- (void)dealloc
{
  if (_isLogin) {
    [_logInForm removeObserver:self forKeyPath:@"userNameField.text"];
    [_logInForm removeObserver:self forKeyPath:@"passwordField.text"];
  }else{
    [_signUpForm removeObserver:self forKeyPath:@"userNameField.text"];
    [_signUpForm removeObserver:self forKeyPath:@"passwordField.text"];
    [_signUpForm removeObserver:self forKeyPath:@"emailField.text"];
  }
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self prepareCredentialsDictionary];
  
  [self.view setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.f]];
  
  if (!_userEntry) {
    _userEntry = [[UserEntry alloc] init];
    [_userEntry setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_userEntry];
    
    [self constraintsForForm:_userEntry];
  }
  
  CGSize maxSize = CGSizeMake(280.f, 200.f);
  
  _titleLabel = [[UILabel alloc] init];
  CGSize requiredSize = [_titleLabel sizeThatFits:maxSize];
  [_titleLabel setFrame:CGRectMake(0.f, 0.f, requiredSize.width, requiredSize.height)];
  [_titleLabel setTextColor:[UIColor colorWithWhite:.3f alpha:1.f]];
  [_titleLabel setBackgroundColor:[UIColor clearColor]];
  [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:52]];
  [_titleLabel setText:@"DAY \n TODAY"];
  [_titleLabel setNumberOfLines:2];
  [_titleLabel setTextAlignment:NSTextAlignmentCenter];
  [_titleLabel sizeToFit];
  [_titleLabel setCenter:CGPointMake(self.view.frame.size.width/2, _titleLabel.center.y + 20)];
  [self.view addSubview:_titleLabel];
}

- (void)setStateForSignUp:(UIButton *)sender
{
  _isLogin = NO;
  [self animateToForm];
}

- (void)setStateForLogIn:(UIButton *)sender
{
  _isLogin = YES;
  [self animateToForm];
}

#pragma mark - KVO Observation and Credential Validation

- (void)prepareCredentialsDictionary
{
  _credentialsDictionary = [[NSMutableDictionary alloc] init];
  
  [_credentialsDictionary setObject:[NSNull null] forKey:@"userNameField.text"];
  [_credentialsDictionary setObject:[NSNull null] forKey:@"passwordField.text"];
  [_credentialsDictionary setObject:[NSNull null] forKey:@"emailField.text"];
}

- (void)addObserversForState
{
  if (_isLogin) {
    [_logInForm addObserver:self forKeyPath:@"userNameField.text" options:NSKeyValueObservingOptionNew context:NULL];
    [_logInForm addObserver:self forKeyPath:@"passwordField.text" options:NSKeyValueObservingOptionNew context:NULL];
  }else{
    [_signUpForm addObserver:self forKeyPath:@"userNameField.text" options:NSKeyValueObservingOptionNew context:NULL];
    [_signUpForm addObserver:self forKeyPath:@"passwordField.text" options:NSKeyValueObservingOptionNew context:NULL];
    [_signUpForm addObserver:self forKeyPath:@"emailField.text"    options:NSKeyValueObservingOptionNew context:NULL];
  }
}

- (void)removeObserversForState
{
  if (_isLogin) {
    [_signUpForm removeObserver:self forKeyPath:@"userNameField.text"];
    [_signUpForm removeObserver:self forKeyPath:@"passwordField.text"];
    [_signUpForm removeObserver:self forKeyPath:@"emailField.text"];
  }else{
    [_logInForm removeObserver:self forKeyPath:@"userNameField.text"];
    [_logInForm removeObserver:self forKeyPath:@"passwordField.text"];
  }
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
  // Observe the emailaddress, username, and password textfields
  [self.credentialsDictionary  setObject:[change objectForKey:NSKeyValueChangeNewKey] forKey:keyPath];
  
  for (NSString *thekey in self.credentialsDictionary) {
    NSLog(@"the keys :%@ and object: %@",thekey, [self.credentialsDictionary objectForKey:thekey]);
  }
}

- (BOOL)hasValidCredentialsForState
{
  
  if (_isLogin) {
    return ( (![[self.credentialsDictionary objectForKey:@"userNameField.text"] isEqual:[NSNull null]] &&
             ![[self.credentialsDictionary objectForKey:@"passwordField.text"] isEqual:[NSNull null]]) ||
            (![[self.credentialsDictionary objectForKey:@"emailField.text"] isEqual:[NSNull null]] &&
             ![[self.credentialsDictionary objectForKey:@"passwordField.text"] isEqual:[NSNull null]] ));
  }else {
    return (![[self.credentialsDictionary objectForKey:@"userNameField.text"] isEqual:[NSNull null]] &&
            ![[self.credentialsDictionary objectForKey:@"passwordField.text"] isEqual:[NSNull null]] &&
            ![[self.credentialsDictionary objectForKey:@"emailField.text"] isEqual:[NSNull null]]);
  }
}

- (void)signupOrLogin:(id)sender
{
  PFUser *user = [PFUser user];
  [user setObject:@([DTCommonUtilities minutesFromGMTForDate:[NSDate date]]) forKey:kDTUserGMTOffset];
  
  if(_isLogin && [self hasValidCredentialsForState]) {
    NSString *loginCredential;
    if (![[self.credentialsDictionary objectForKey:@"userNameField.text"] isEqual:[NSNull null]]) {
      loginCredential = [self.credentialsDictionary objectForKey:@"userNameField.text"];
    }else {
      loginCredential = [self.credentialsDictionary objectForKey:@"emailField.text"];
    }
    [PFUser logInWithUsernameInBackground:loginCredential password:[self.credentialsDictionary objectForKey:@"passwordField.text"]
                                    block:^(PFUser *user, NSError *error) {
                                      if (user) {
                                        NIDINFO(@"logged in");
                                      } else {
                                        NIDINFO(@"%@",[error localizedDescription]);
                                      }
                                    }];
  }
  else if (!_isLogin && [self hasValidCredentialsForState]) {
    user.username = [self.credentialsDictionary objectForKey:@"userNameField.text"];
    user.password = [self.credentialsDictionary objectForKey:@"passwordField.text"];
    user.email    = [self.credentialsDictionary objectForKey:@"emailField.text"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      if (!error) {
        NIDINFO(@"signed up");
      } else {
        NIDINFO(@"%@",[error localizedDescription]);
      }
    }];
  }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NIDINFO(@"clicked on %d",buttonIndex);
}

#pragma mark - Login View Flow and Animations

- (CGSize)sizeForTitleAnimation
{
  _titleLabel.text = @"DAY TODAY";
  [_titleLabel setNumberOfLines:1];
  CGSize maxSize = CGSizeMake(280.f, 60.f);
  CGSize requiredSize = [_titleLabel sizeThatFits:maxSize];
  [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
  [_titleLabel sizeToFit];

  return requiredSize;
}

- (void)animateToForm
{
  //if state is login --> transition to login
  if (_isLogin) {
    if (!_logInForm) {
      _logInForm = [[LogInForm alloc] init];
      [_logInForm setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self.view addSubview:_logInForm];

      [self constraintsForForm:_logInForm];

      _logInForm.transform = CGAffineTransformMakeTranslation(1*self.view.frame.size.width, 0);
    }
  }

  //if the state is not login --> transition to signup
  if (!_isLogin) {
    if (!_signUpForm) {
      _signUpForm = [[SignUpForm alloc] init];
      [_signUpForm setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self.view addSubview:_signUpForm];

      [self constraintsForForm:_signUpForm];

      _signUpForm.transform = CGAffineTransformMakeTranslation(-1*self.view.frame.size.width, 0);
    }
  }

  [self addObserversForState];

  [UIView animateWithDuration:.42f
                   animations:^{
                     if (![_titleLabel.text isEqualToString:@"DAY TODAY"]) {
                       [_titleLabel setFrame:CGRectMake(0.f, 20.f, 320.f, [self sizeForTitleAnimation].height)];
                     }
                     [_userEntry setAlpha:0.0f];
                     if (!_isLogin) {
                       _signUpForm.transform = CGAffineTransformMakeTranslation(0, 0);
                       if (_logInForm) {
                         [_logInForm setAlpha:0.0f];
                         [_signUpForm setAlpha:1.0f];
                       }
                     }
                     else {
                       _logInForm.transform = CGAffineTransformMakeTranslation(0, 0);
                       if (_signUpForm) {
                         [_signUpForm setAlpha:0.0f];
                         [_logInForm setAlpha:1.0f];
                       }
                     }
                   }
                   completion:^(BOOL finished){
                     [self removeObserversForState];
                   }];
}

#pragma mark - Constraints for login views

- (void)constraintsForForm:(UIView *)form
{
  if ([form isKindOfClass:[SignUpForm class]]) {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[signUp]-(20)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"signUp":_signUpForm}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[signUp(240)]"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"signUp":_signUpForm}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_signUpForm
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_signUpForm.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0]];
  }

  if ([form isKindOfClass:[LogInForm class]]) {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[logIn]-(20)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"logIn":_logInForm}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[logIn(240)]"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"logIn":_logInForm}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logInForm
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_logInForm.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0]];
  }

  if ([form isKindOfClass:[UserEntry class]]) {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[entry]-(20)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"entry":_userEntry}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(160)-[entry(80)]"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:@{@"entry": _userEntry}]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_userEntry
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_userEntry.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0]];
  }

  [self.view layoutIfNeeded];
}
@end