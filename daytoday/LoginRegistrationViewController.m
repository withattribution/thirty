//
//  LoginRegistrationViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "LoginRegistrationViewController.h"
#import "ProfileViewController.h"

#import "UIColor+SR.h"

#import <FacebookSDK/FacebookSDK.h>

#import "SignUpForm.h"
#import "UserEntry.h"
#import "LogInForm.h"

@interface LoginRegistrationViewController () <UIScrollViewDelegate,
                                      AuthenticationRequestDelegate,
                                                UserRequestDelegate,
                                                UIAlertViewDelegate,
                                                UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void) toggleSignupButton:(id)sender;
- (void) signupOrLogin:(id)sender;
- (void) facebookLogin:(id)sender;

@end

@implementation LoginRegistrationViewController {
  UserEntry *_userEntry;
  SignUpForm *_signUpForm;
  LogInForm  *_logInForm;
}

- (void) toggleSignupButton:(id)sender
{

    NSString *orsignup = NSLocalizedString(@"or Signup",@"or signup if you have to");
    NSString *login = NSLocalizedString(@"Log In", @"Log In as a header or button field");
    NSString *orlogin = NSLocalizedString(@"or Login",@"or login if you already have an account");
    NSString *signup = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
    if( isLogin ){
      [self.scrollView setContentOffset:CGPointMake(320*1, 0) animated:YES];

        [switchButton setTitle:orsignup forState:UIControlStateNormal];
        [signupButton setTitle:login forState:UIControlStateNormal];
    }else{
      [self.scrollView setContentOffset:CGPointMake(320*0, 0) animated:YES];

        [switchButton setTitle:orlogin forState:UIControlStateNormal];
        [signupButton setTitle:signup forState:UIControlStateNormal];
    }
    isLogin = !isLogin;
}

- (void)displayLoginForm:(UIButton  *)sender
{
  _titleLabel.text = @"DAY TODAY";
  [_titleLabel setNumberOfLines:1];
  CGSize maxSize = CGSizeMake(280.f, 60.f);
  CGSize requiredSize = [_titleLabel sizeThatFits:maxSize];
  [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
  [_titleLabel sizeToFit];
  
  _logInForm = [[LogInForm alloc] init];
  [_logInForm setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_signUpForm setBackgroundColor:[UIColor redColor]];
  [self.view addSubview:_logInForm];
  
  
  
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
  
  [self.view layoutIfNeeded];
  
  _logInForm.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
  
  [UIView animateWithDuration:.42f
                   animations:^{
                     //                     [_titleLabel setCenter:CGPointMake(self.view.frame.size.width/2, _titleLabel.center.y + 20)];
                     [_titleLabel setFrame:CGRectMake(0.f, 20.f, 320.f, requiredSize.height)];
                     [_userEntry setAlpha:0.0f];
                     _logInForm.transform = CGAffineTransformMakeTranslation(0, 0);
                   }
                   completion:^(BOOL finished){
                     
                   }];
}
- (void)displaySignUpForm:(UIButton  *)sender
{
    _titleLabel.text = @"DAY TODAY";
  [_titleLabel setNumberOfLines:1];
  CGSize maxSize = CGSizeMake(280.f, 60.f);
  CGSize requiredSize = [_titleLabel sizeThatFits:maxSize];
  [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
  [_titleLabel sizeToFit];
  
  _signUpForm = [[SignUpForm alloc] init];
  [_signUpForm setTranslatesAutoresizingMaskIntoConstraints:NO];
//  [_signUpForm setBackgroundColor:[UIColor redColor]];
  [self.view addSubview:_signUpForm];



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
  
  [self.view layoutIfNeeded];
  
  _signUpForm.transform = CGAffineTransformMakeTranslation(-1*self.view.frame.size.width, 0);

  [UIView animateWithDuration:.42f
                   animations:^{
//                     [_titleLabel setCenter:CGPointMake(self.view.frame.size.width/2, _titleLabel.center.y + 20)];
                     [_titleLabel setFrame:CGRectMake(0.f, 20.f, 320.f, requiredSize.height)];
                     [_userEntry setAlpha:0.0f];
                     _signUpForm.transform = CGAffineTransformMakeTranslation(0, 0);
                   }
                   completion:^(BOOL finished){
                     
                   }];
}

- (void) signupOrLogin:(id)sender
{
  
  if( !isLogin )
      [authenticationRequest loginUser:emailField.text withPassword:passwordField.text];
  else
      [userRequest createUser:emailField.text withPassword:passwordField.text additionalParameters:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

//  self.title = NSLocalizedString(@"Login or Register", @"title for login/reg page");
  [self.view setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.f]];
  
  _userEntry = [[UserEntry alloc] init];
  [_userEntry setTranslatesAutoresizingMaskIntoConstraints:NO];
//  [_userEntry setBackgroundColor:[UIColor redColor]];
  
  [self.view addSubview:_userEntry];
  
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
  
  [self.view layoutIfNeeded];
  
  //user request object
  userRequest = [[UserRequest alloc] initWithContext:self.context];
  userRequest.delegate = self;
  authenticationRequest = [[AuthenticationRequest alloc] initWithContext:self.context];
  authenticationRequest.delegate = self;
  
  
  CGSize maxSize = CGSizeMake(280.f, 200.f);
  
  _titleLabel = [[UILabel alloc] init];
  CGSize requiredSize = [_titleLabel sizeThatFits:maxSize];
  _titleLabel.frame = CGRectMake(0.f, 0.f, requiredSize.width, requiredSize.height);
  
  _titleLabel.textColor = [UIColor colorWithWhite:.3f alpha:1.f];
  _titleLabel.backgroundColor = [UIColor clearColor];
  _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:52];
  _titleLabel.text = @"DAY \n TODAY";
  _titleLabel.numberOfLines = 2;
  _titleLabel.textAlignment = NSTextAlignmentCenter;
//  [_titleLabel.layer setBorderColor:[UIColor brownColor].CGColor];
//  [_titleLabel.layer setBorderWidth:1.f];
  [_titleLabel sizeToFit];
  [_titleLabel setCenter:CGPointMake(self.view.frame.size.width/2, _titleLabel.center.y + 20)];
  [self.view addSubview:_titleLabel];



//  emailField = [[UITextField alloc] initWithFrame:CGRectMake((320-100)/2, 100.f, 100.f, 30.f)];
//  passwordField = [[UITextField alloc] initWithFrame:CGRectMake((320-100)/2, 150.f, 100.f, 30.f)];
//  emailField.autocorrectionType = UITextAutocorrectionTypeNo;
//  passwordField.secureTextEntry = YES;
//  passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
//  
//  CGRect uname = CGRectMake(emailField.frame.origin.x-100, emailField.frame.origin.y, emailField.frame.size.width, emailField.frame.size.height);
//  usernameLabel = [[UILabel alloc] initWithFrame:uname];
//  CGRect pword = CGRectMake(passwordField.frame.origin.x-100, passwordField.frame.origin.y, passwordField.frame.size.width, passwordField.frame.size.height);
//  passwordLabel = [[UILabel alloc] initWithFrame:pword];
//  usernameLabel.backgroundColor = [UIColor clearColor];
//  passwordLabel.backgroundColor = [UIColor clearColor];
//  usernameLabel.textColor = [UIColor blackColor];
//  passwordLabel.textColor = [UIColor blackColor];
//  [usernameLabel setText:NSLocalizedString(@"username:", @"username: ")];
//  [passwordLabel setText:NSLocalizedString(@"password:", @"password: ")];
//  [self.view addSubview:usernameLabel];
//  [self.view addSubview:passwordLabel];
//  
//  
//  emailField.backgroundColor = [UIColor randomColor];
//  passwordField.backgroundColor = [UIColor randomColor];
//  
//  [self.view addSubview:emailField];
//  [self.view addSubview:passwordField];
//  isLogin = YES;
  
//get this outta here
//  [switchButton setTitle:NSLocalizedString(@"or Login",@"or login if you already have an account") forState:UIControlStateNormal];
//  switchButton.frame = CGRectMake(250, 250, 80, 20);
//  [switchButton addTarget:self action:@selector(toggleSignupButton:) forControlEvents:UIControlEventTouchUpInside];
//  switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//  [switchButton setBackgroundColor:[UIColor randomColor]];
//
//  [self.view addSubview:switchButton];
  



//  IFTTTFrameAnimation *frameAnimation = [IFTTTFrameAnimation new];
//  frameAnimation.view = emailField;
//  
//  [self.animator addAnimation:frameAnimation];
//  
//  [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:150 andFrame:CGRectMake(10, 10, 100, 100)]];
//  [frameAnimation addKeyFrame:[[IFTTTAnimationKeyFrame alloc] initWithTime:0 andFrame:CGRectMake(150, 10, 200, 200)]];
  
  
}

#pragma mark - Facebook Session Methods
//https://developers.facebook.com/docs/ios/ios-sdk-tutorial/authenticate/
//https://developers.facebook.com/docs/ios/ios-sdk-tutorial/
//https://developers.facebook.com/apps/305208832954290/summary?save=1
//https://developers.facebook.com/docs/ios/share-appid-across-multiple-apps-ios-sdk/
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
  NIDINFO(@"session state changed!");
  NIDINFO(@"session accesstoken: %@",session.accessTokenData);
  switch (state) {
    case FBSessionStateOpen: {
      NIDINFO(@"session accesstoken: %@",session.accessTokenData);
      if( [[NSUserDefaults standardUserDefaults] valueForKey:kFacebookAuthToken] == nil ){
        [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData forKey:kFacebookAuthToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
      }
      
      [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^(void){
        NIDINFO(@"fb session looks like: %@",session.accessTokenData);
        
      }];
    }
      break;
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      // Once the user has logged in, we want them to
      // be looking at the root view.
      [self.navigationController popToRootViewControllerAnimated:NO];
      
      [FBSession.activeSession closeAndClearTokenInformation];
      
      break;
    default:
      break;
  }
  
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}

- (void) facebookLogin:(id)sender
{
  NIDINFO(@"facebook login button touched!");
  [FBSession openActiveSessionWithReadPermissions:nil
                                     allowLoginUI:YES
                                completionHandler:
   ^(FBSession *session,
     FBSessionState state, NSError *error) {
     [self sessionStateChanged:session state:state error:error];
   }];
}

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
@end
