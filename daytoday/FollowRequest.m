//
//  FollowRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/21/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "FollowRequest.h"

@implementation FollowRequest
- (void) followUser:(NSNumber*)userId
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"user_id" : userId, @"follow" : [NSNumber numberWithBool:YES] }];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/follow" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if( [jsonDict validKey:@"success"] && [jsonDict validKey:@"following"] && [self.delegate respondsToSelector:@selector(successfullyFollowed:)] )
            [self.delegate successfullyFollowed:[Follow fromDictionary:(NSDictionary*)[jsonDict valueForKey:@"following"] inContext:self.context]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}

- (void) unfollowUser:(NSNumber*)userId
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"user_id" : userId, @"follow" : [NSNumber numberWithBool:NO] }];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/follow" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [self.delegate respondsToSelector:@selector(succesfullyUnfollowed)] )
                [self.delegate succesfullyUnfollowed];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
@end
