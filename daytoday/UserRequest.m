//
//  UserRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

- (void) createUser:(NSString*) username withPassword:(NSString*)pw
{
    //NSMutableURLRequest* req = [[self client] requestWithMethod:@"PUT" path:@"/user" parameters:@{@"username" : username, @"pass" : pw}];
    //[[self client]
    [[self client] putPath:@"/user" parameters:@{@"username" : username, @"pass" : pw} success:^(AFHTTPRequestOperation *req, id responseObject){
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void) getUser:(NSNumber*)userId
{
    
}
- (void) updateUserWithParameters:(NSDictionary*)dict
{
    
}

@end
