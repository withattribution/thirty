//
//  LoginRegistrationViewController.m
//  daytoday
//
//  Created by Alberto Tafoya on 10/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "LoginRegistrationViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SignUpForm.h"
#import "UserEntry.h"
#import "LogInForm.h"

@interface LoginRegistrationViewController () <UIAlertViewDelegate>
{
  UILabel *_titleLabel;
}

- (void)constraintsForView:(UIView *)view;
- (CGSize)sizeForTitleAnimation;
- (void)animateToView:(UIView *)view;

@end

@implementation LoginRegistrationViewController {
  UserEntry *_userEntry;
  SignUpForm *_signUpForm;
  LogInForm  *_logInForm;
  
  UIView *entryContainer;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.f]];
  
  if (!_userEntry) {
    _userEntry = [[UserEntry alloc] init];
    [_userEntry setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_userEntry];
    
    [self constraintsForView:_userEntry];
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
  if (!_signUpForm) {
    _signUpForm = [[SignUpForm alloc] init];
    [_signUpForm setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_signUpForm];
    
    [self constraintsForView:_signUpForm];
    
    _signUpForm.transform = CGAffineTransformMakeTranslation(-1*self.view.frame.size.width, 0);
  }
  [self animateToView:_signUpForm];
}

- (void)setStateForLogIn:(UIButton *)sender
{
  if (!_logInForm) {
    _logInForm = [[LogInForm alloc] init];
    
    [_logInForm setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_logInForm];
    
    [self constraintsForView:_logInForm];
    
    _logInForm.transform = CGAffineTransformMakeTranslation(1*self.view.frame.size.width, 0);
  }
  [self animateToView:_logInForm];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NIDINFO(@"clicked on %ld",buttonIndex);
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

- (void)animateToView:(UIView *)view
{
  [UIView animateWithDuration:.42f
                   animations:^{
                     if (![_titleLabel.text isEqualToString:@"DAY TODAY"]) {
                       [_titleLabel setFrame:CGRectMake(0.f, 20.f, 320.f, [self sizeForTitleAnimation].height)];
                     }
                     [_userEntry setAlpha:0.0f];
                     if (![view isKindOfClass:[LogInForm class]]) {
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

                   }];
}

#pragma mark - Constraints for login views

- (void)constraintsForView:(UIView *)view
{
  if ([view isKindOfClass:[SignUpForm class]]) {
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

  if ([view isKindOfClass:[LogInForm class]]) {
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

  if ([view isKindOfClass:[UserEntry class]]) {
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