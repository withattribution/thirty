//
//  IntentRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "IntentRequest.h"

@implementation IntentRequest
@synthesize delegate;

- (void) createIntent:(NSDictionary*)params
{
    [params assertKey:@"challenge"];
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier]}];
    [d1 addEntriesFromDictionary:params];
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/intent" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"intent"] ){
            Intent *u = [Intent fromDictionary:[jsonDict valueForKey:@"intent"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(createdIntent:)] )
                [self.delegate createdIntent:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) deleteIntent:(NSNumber*)intentId
{
    
}
@end
