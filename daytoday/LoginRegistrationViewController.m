//
//  LoginRegistrationViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "LoginRegistrationViewController.h"
#import "ProfileViewController.h"


#import "SignUpForm.h"
#import "UserEntry.h"
#import "LogInForm.h"

@interface LoginRegistrationViewController () <AuthenticationRequestDelegate,UserRequestDelegate,UIAlertViewDelegate>
{
  BOOL _isLogin;
  UILabel *_titleLabel;
  
  UserRequest *userRequest;
  AuthenticationRequest *authenticationRequest;
}

@property (nonatomic,strong) NSMutableDictionary *credentialsDictionary;

- (void)signupOrLogin:(id)sender;
- (void)facebookLogin:(id)sender;

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

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self prepareCredentialsDictionary];
  
  userRequest = [[UserRequest alloc] initWithContext:self.context];
  [userRequest setDelegate:self];
  
  authenticationRequest = [[AuthenticationRequest alloc] initWithContext:self.context];
  [authenticationRequest setDelegate:self];
  
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
  
  [_credentialsDictionary setObject:[NSNull null] forKey:@"username"];
  [_credentialsDictionary setObject:[NSNull null] forKey:@"password"];
  [_credentialsDictionary setObject:[NSNull null] forKey:@"email"];
}

- (void)addObserversForState
{
  if (_isLogin) {
    [_logInForm addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew context:NULL];
    [_logInForm addObserver:self forKeyPath:@"password" options:NSKeyValueObservingOptionNew context:NULL];
  }else{
    [_signUpForm addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew context:NULL];
    [_signUpForm addObserver:self forKeyPath:@"password" options:NSKeyValueObservingOptionNew context:NULL];
    [_signUpForm addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew context:NULL];
  }
}

- (void)removeObserversForState
{
  if (_isLogin) {
    [_signUpForm removeObserver:self forKeyPath:@"username"];
    [_signUpForm removeObserver:self forKeyPath:@"password"];
    [_signUpForm removeObserver:self forKeyPath:@"email"];
  }else{
    [_logInForm removeObserver:self forKeyPath:@"username"];
    [_logInForm removeObserver:self forKeyPath:@"password"];
  }
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
  // Observe the emailaddress, username, and password textfields
  [self.credentialsDictionary  setObject:[change objectForKey:NSKeyValueChangeNewKey] forKey:keyPath];
  
//  for (NSString *thekey in self.credentialsDictionary) {
//    NSLog(@"the keys :%@ and object: %@",thekey, [self.credentialsDictionary objectForKey:thekey]);
//  }
}

- (BOOL)hasValidCredentialsForState
{
  if (_isLogin) {
    
#warning logic in place to accept username or email but pretty sure this is not what's being allowed on the service side yet
    return ( (![[self.credentialsDictionary objectForKey:@"username"] isEqual:[NSNull null]] &&
             ![[self.credentialsDictionary objectForKey:@"password"] isEqual:[NSNull null]]) ||
            (![[self.credentialsDictionary objectForKey:@"email"] isEqual:[NSNull null]] &&
             ![[self.credentialsDictionary objectForKey:@"password"] isEqual:[NSNull null]] ));
  }else {
    return (![[self.credentialsDictionary objectForKey:@"username"] isEqual:[NSNull null]] &&
            ![[self.credentialsDictionary objectForKey:@"password"] isEqual:[NSNull null]] &&
            ![[self.credentialsDictionary objectForKey:@"email"] isEqual:[NSNull null]]);
  }
}

- (void)signupOrLogin:(id)sender
{
#warning not sendind optional email as username since it's not implemented service side
  if(_isLogin && [self hasValidCredentialsForState])
    [authenticationRequest loginUser:[self.credentialsDictionary objectForKey:@"username"]
                        withPassword:[self.credentialsDictionary objectForKey:@"password"]];

#warning not sending email since not sure if it's being processed service side
  else if ([self hasValidCredentialsForState])
    [userRequest createUser:[self.credentialsDictionary objectForKey:@"username"]
               withPassword:[self.credentialsDictionary objectForKey:@"password"]
       additionalParameters:nil];
}

#pragma mark - Facebook Session Methods
//https://developers.facebook.com/docs/ios/ios-sdk-tutorial/authenticate/
//https://developers.facebook.com/docs/ios/ios-sdk-tutorial/
//https://developers.facebook.com/apps/305208832954290/summary?save=1
//https://developers.facebook.com/docs/ios/share-appid-across-multiple-apps-ios-sdk/
//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//  NIDINFO(@"session state changed!");
//  NIDINFO(@"session accesstoken: %@",session.accessTokenData);
//  switch (state) {
//    case FBSessionStateOpen: {
//      NIDINFO(@"session accesstoken: %@",session.accessTokenData);
//      if( [[NSUserDefaults standardUserDefaults] valueForKey:kFacebookAuthToken] == nil ){
//        [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData forKey:kFacebookAuthToken];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//      }
//
//      [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^(void){
//        NIDINFO(@"fb session looks like: %@",session.accessTokenData);
//
//      }];
//    }
//      break;
//    case FBSessionStateClosed:
//    case FBSessionStateClosedLoginFailed:
//      // Once the user has logged in, we want them to
//      // be looking at the root view.
//      [self.navigationController popToRootViewControllerAnimated:NO];
//      [FBSession.activeSession closeAndClearTokenInformation];
//      break;
//    default:
//      break;
//  }
//
//  if (error) {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:error.localizedDescription
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    [alertView show];
//  }
//}

//- (void) facebookLogin:(id)sender
//{
//  NIDINFO(@"facebook login button touched!");
//  [FBSession openActiveSessionWithReadPermissions:nil
//                                     allowLoginUI:YES
//                                completionHandler:
//   ^(FBSession *session,
//     FBSessionState state, NSError *error) {
//     [self sessionStateChanged:session state:state error:error];
//   }];
//}

#pragma mark - UserRequestDelegate
- (void) userCreatedSuccesfully:(User*)user
{
  ProfileViewController *pvc = [[ProfileViewController alloc] init];
  [self.navigationController pushViewController:pvc animated:YES];
}

- (void) gotUser:(User*)user
{
  NIDINFO(@"got the user: %@",user);
}

- (void) userUpdated:(User*)user
{
  NIDINFO(@"updated the user: %@",user);
}

#pragma mark - AuthenticationRequestDelegate

-(void) authenticationSuccessful:(User*)user
{
  ProfileViewController *pvc = [[ProfileViewController alloc] init];
  [self.navigationController pushViewController:pvc animated:YES];
}

-(void) logoutSuccessful
{
  NIDINFO(@"logoutSuccessful");
}

- (void) requestDidError:(NSError*)err
{
  NIDERROR(@"server error! :%@",[err localizedDescription]);
  NSString *title = NSLocalizedString(@"Oh Shit", @"alert view title for registration page");
  NSString *message = NSLocalizedString(@"username or password nonsense", @"reason why the alert view");
  NSString *cancel = NSLocalizedString(@"Nevermind", @"Cancel/OK");
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil];
  
  [alertView show];
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