//
//  AuthenticationRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"
#import "User+D2D.h"

@protocol AuthenticationRequestDelegate <D2RequestDelegate>

-(void) authenticationSuccessful:(User*)user;
-(void) logoutSuccessful;

@end

@interface AuthenticationRequest : D2Request
@property(nonatomic,weak) id <AuthenticationRequestDelegate> delegate;
- (void) loginUser:(NSString*) username withPassword:(NSString*)pw;
- (void) logoutDevice;
@end
