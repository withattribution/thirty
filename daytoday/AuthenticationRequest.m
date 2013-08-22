//
//  AuthenticationRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "AuthenticationRequest.h"

@implementation AuthenticationRequest
- (void) loginUser:(NSString*) username withPassword:(NSString*)pw
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"username" : username, @"password" : pw, @"phone" : [self identifier]}];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/auth" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        NIDINFO(@"authentication result: %@",JSON);
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"user"] ){
            User *u = [User fromDictionary:[jsonDict valueForKey:@"user"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(authenticationSuccessful:)] )
                [self.delegate authenticationSuccessful:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
        NIDERROR(@"%@",JSON);
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}

- (void) logoutDevice
{
    [self resetIdentifier];
    if( self.delegate && [self.delegate respondsToSelector:@selector(logoutSuccessful)] )
        [self.delegate logoutSuccessful];
    
}
@end
