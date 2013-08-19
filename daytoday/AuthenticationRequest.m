//
//  AuthenticationRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "AuthenticationRequest.h"

@implementation AuthenticationRequest
-(NSURL*) url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth",self.baseURL]];
    
}
@end
