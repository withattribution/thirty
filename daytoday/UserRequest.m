//
//  UserRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "UserRequest.h"
#import "User+D2D.h"

@implementation UserRequest

@synthesize delegate;


- (void) createUser:(NSString*) username withPassword:(NSString*)pw additionalParameters:(NSDictionary*)params
{

    
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"username" : username, @"pass" : pw, @"phone" : [self identifier]}];
    [d1 addEntriesFromDictionary:params];

    NSMutableURLRequest *req = [self.client requestWithMethod:@"PUT" path:@"/user" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NIDINFO(@" json response : %@",JSON);
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"user"] ){
            User *u = [User fromDictionary:[jsonDict valueForKey:@"user"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(userCreatedSuccesfully:)] )
                [self.delegate userCreatedSuccesfully:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];

}
- (void) getUser:(NSNumber*)userId
{
    
}

- (void) updateUserWithParameters:(NSDictionary*)dict
{
    
}

@end
