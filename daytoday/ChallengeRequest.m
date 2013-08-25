//
//  ChallengeRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/21/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeRequest.h"
#import "Challenge+D2D.h"

@implementation ChallengeRequest
@synthesize delegate;

- (void) createChallenge:(NSDictionary*)params
{
    [params assertKey:@"name"];
    [params assertKey:@"description"];
    
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier]}];
    [d1 addEntriesFromDictionary:params];
    NSMutableURLRequest *req = [self.client requestWithMethod:@"PUT" path:@"/challenge" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"challenge"] ){
            Challenge *u = [Challenge fromDictionary:[jsonDict valueForKey:@"challenge"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(challengeSuccessfullyCreated:)] )
                [self.delegate challengeSuccessfullyCreated:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) updateChallenge:(NSDictionary*)params
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier]}];
    [d1 addEntriesFromDictionary:params];
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/challenge" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"challenge"] ){
            Challenge *u = [Challenge fromDictionary:[jsonDict valueForKey:@"challenge"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(updatedChallenge:)] )
                [self.delegate updatedChallenge:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) getChallenge:(NSNumber*)challengeId
{
    NSDictionary* d1 = @{@"auth" : [self identifier], @"id" : challengeId };
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"GET" path:@"/challenge" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"challenge"] ){
            Challenge *u = [Challenge fromDictionary:[jsonDict valueForKey:@"challenge"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(gotChallenge:)] )
                [self.delegate gotChallenge:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}

@end
