//
//  AuthenticationRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
@protocol AuthenticationRequestDelegate <D2RequestDelegate>

-(void) authenticationSuccessful;

@end

@interface AuthenticationRequest : D2Request

@property(nonatomic,weak) id <AuthenticationRequestDelegate> delegate;

@end
