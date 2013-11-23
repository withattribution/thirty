//
//  CommentRequest.m
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "CommentRequest.h"

@implementation CommentRequest
- (void) createComment:(ChallengeDay*)cd comment:(NSString*)comment
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"challenge_day" : cd.challengeDayId, @"comment" : comment }];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"POST" path:@"/comment" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] && [jsonDict valueForKey:@"comment"] ){
            Comment *u = [Comment fromDictionary:[jsonDict valueForKey:@"comment"] inContext:self.context];
            if( [self.delegate respondsToSelector:@selector(createdComment:)] )
                [self.delegate createdComment:u];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) deleteComment:(NSNumber*)commentId
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier], @"comment_id" : commentId }];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"DELETE" path:@"/comment" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        if([jsonDict valueForKey:@"success"] ){
            if( [self.delegate respondsToSelector:@selector(deletedComment)] )
                [self.delegate deletedComment];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
@end
