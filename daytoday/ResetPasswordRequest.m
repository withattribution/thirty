//
//  ResetPasswordRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/26/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ResetPasswordRequest.h"

@implementation ResetPasswordRequest
@synthesize delegate;

- (void) resetPassword:(NSString*)oldPassword newPassword:(NSString*)np
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"old_password" : oldPassword, @"new_password" : np, @"auth" : [self identifier]}];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/resetpassword" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"user"] )
           if( self.delegate && [self.delegate respondsToSelector:@selector(passwordResetSuccessful)])
              [self.delegate passwordResetSuccessful];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
        NIDERROR(@"%@",JSON);
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}

@end
