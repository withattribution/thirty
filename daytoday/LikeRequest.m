//
//  LikeRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "LikeRequest.h"

@implementation LikeRequest
@synthesize delegate;

- (void) like:(ChallengeDay*)cd
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"challenge_day" : cd.challengeDayId }];

    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/like" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"like"] ){
            Like *u = [Like fromDictionary:[jsonDict valueForKey:@"like"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(successfullyLiked:)] )
                [self.delegate successfullyLiked:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) unlike:(ChallengeDay*)cd
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"challenge_day" : cd.challengeDayId }];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"DELETE" path:@"/like" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"removed"] && [jsonDict valueForKey:@"success"] ){
            if( [self.delegate respondsToSelector:@selector(successfullyUnliked)] )
                [self.delegate successfullyUnliked];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
@end
