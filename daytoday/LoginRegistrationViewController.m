//
//  LoginRegistrationViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "LoginRegistrationViewController.h"
#import "UIColor+SR.h"
#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LoginRegistrationViewController ()
- (IBAction) toggleSignupButton:(id)sender;
- (IBAction) signupOrLogin:(id)sender;
- (IBAction) facebookLogin:(id)sender;
@end

@implementation LoginRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        emailField = [[UITextField alloc] initWithFrame:CGRectMake((320-100)/2, 100.f, 100.f, 30.f)];
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake((320-100)/2, 150.f, 100.f, 30.f)];
        emailField.autocorrectionType = UITextAutocorrectionTypeNo;
        passwordField.secureTextEntry = YES;
        passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        CGRect uname = CGRectMake(emailField.frame.origin.x-100, emailField.frame.origin.y, emailField.frame.size.width, emailField.frame.size.height);
        usernameLabel = [[UILabel alloc] initWithFrame:uname];
        CGRect pword = CGRectMake(passwordField.frame.origin.x-100, passwordField.frame.origin.y, passwordField.frame.size.width, passwordField.frame.size.height);
        passwordLabel = [[UILabel alloc] initWithFrame:pword];
        usernameLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.backgroundColor = [UIColor clearColor];
        usernameLabel.textColor = [UIColor blackColor];
        passwordLabel.textColor = [UIColor blackColor];
        [usernameLabel setText:NSLocalizedString(@"username:", @"username: ")];
        [passwordLabel setText:NSLocalizedString(@"password:", @"password: ")];
        [self.view addSubview:usernameLabel];
        [self.view addSubview:passwordLabel];
        
        
        emailField.backgroundColor = [UIColor randomColor];
        passwordField.backgroundColor = [UIColor randomColor];
        
        [self.view addSubview:emailField];
        [self.view addSubview:passwordField];
        isLogin = YES;
        signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *signup = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
        [signupButton setTitle:signup forState:UIControlStateNormal];

        signupButton.titleLabel.textColor = [UIColor blackColor];
        signupButton.backgroundColor = [UIColor randomColor];
        [signupButton addTarget:self action:@selector(signupOrLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        signupButton.frame = CGRectMake((320-100)/2,200, 100.f, 30.f);
        switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        switchButton.backgroundColor = [UIColor randomColor];
        [switchButton setTitle:NSLocalizedString(@"or Login",@"or login if you already have an account") forState:UIControlStateNormal];
        switchButton.frame = CGRectMake(250, 250, 80, 20);
        [switchButton addTarget:self action:@selector(toggleSignupButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:signupButton];
        [self.view addSubview:switchButton];
        
        facebookLoginButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        facebookLoginButton.frame = CGRectMake((320-200)/2,300, 200.f, 30.f);
        [facebookLoginButton setTitle:NSLocalizedString(@"Login with Facebook", @"facebook login button") forState:UIControlStateNormal];
        facebookLoginButton.backgroundColor = [UIColor randomColor];
        [facebookLoginButton addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:facebookLoginButton];

        
    }
    return self;
}

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

- (IBAction) facebookLogin:(id)sender
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

- (IBAction) toggleSignupButton:(id)sender
{
    NSString *orsignup = NSLocalizedString(@"or Signup",@"or signup if you have to");
    NSString *login = NSLocalizedString(@"Log In", @"Log In as a header or button field");
    NSString *orlogin = NSLocalizedString(@"or Login",@"or login if you already have an account");
    NSString *signup = NSLocalizedString(@"Sign Up", @"Sign Up as a header or button field");
    if( isLogin ){
        [switchButton setTitle:orsignup forState:UIControlStateNormal];
        [signupButton setTitle:login forState:UIControlStateNormal];
    }else{
        [switchButton setTitle:orlogin forState:UIControlStateNormal];
        [signupButton setTitle:signup forState:UIControlStateNormal];
    }
    isLogin = !isLogin;
    
}

- (IBAction) signupOrLogin:(id)sender
{
    if( !isLogin )
        [authenticationRequest loginUser:emailField.text withPassword:passwordField.text];
    else
        [userRequest createUser:emailField.text withPassword:passwordField.text additionalParameters:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Login or Register", @"title for login/reg page");
    
    userRequest = [[UserRequest alloc] initWithContext:self.context];
    userRequest.delegate = self;
    authenticationRequest = [[AuthenticationRequest alloc] initWithContext:self.context];
    authenticationRequest.delegate = self;

	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark UserRequestDelegate

- (void) userCreatedSuccesfully:(User*)user
{
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (void) gotUser:(User*)user
{
    
}
- (void) userUpdated:(User*)user
{
    
}

#pragma mark -
#pragma mark AuthenticationRequestDelegate

-(void) authenticationSuccessful:(User*)user
{
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
-(void) logoutSuccessful
{
    
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
