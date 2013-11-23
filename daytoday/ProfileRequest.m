//
//  ProfileRequest.m
//  daytoday
//
//  Created by Anderson Miller on 9/9/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ProfileRequest.h"

@implementation ProfileRequest
@synthesize delegate;
- (void) getMyProfile
{
    NSMutableDictionary* d1 = [[NSMutableDictionary alloc] initWithDictionary:@{@"auth" : [self identifier]}];
    
    NSMutableURLRequest *req = [self.client requestWithMethod:@"GET" path:@"/profile" parameters:[NSDictionary dictionaryWithDictionary:d1]];
    
    AFJSONRequestOperation* jrequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary* jsonDict = (NSDictionary*)JSON;
        NIDINFO(@"json dictionary for profile: %@",jsonDict);
        if([jsonDict valueForKey:@"success"] )
            if( self.delegate && [self.delegate respondsToSelector:@selector(gotProfile:)])
                [self.delegate gotProfile:nil];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(self.delegate)
            [self.delegate requestDidError:error];
        NIDERROR(@"%@",JSON);
    }];
    [self.client enqueueHTTPRequestOperation:jrequest];
}
- (void) getProfileForUser:(NSNumber*)userId
{
    
}
@end
