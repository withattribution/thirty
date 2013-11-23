//
//  TickRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/25/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "TickRequest.h"

@implementation TickRequest
@synthesize delegate;

- (void) makeTick:(NSDictionary*)params
{
    [params assertKey:@"intent"];
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier]}];
    [d1 addEntriesFromDictionary:params];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/tick" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if( [jsonDict validKey:@"success"] && [jsonDict validKey:@"challenge_day"] && [jsonDict validKey:@"tick"] && [self.delegate respondsToSelector:@selector(tickAccepted:andTick:)] ){
            ChallengeDay* cd = [ChallengeDay fromDictionary:(NSDictionary*)[jsonDict valueForKey:@"challenge_day"] inContext:self.context];
            Tick* t = [Tick fromDictionary:(NSDictionary*)[jsonDict valueForKey:@"tick"] inContext:self.context];
            [self.delegate tickAccepted:cd andTick:t];
        }
           
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}

@end
