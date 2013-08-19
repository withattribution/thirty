//
//  D2Request.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"

@implementation D2Request
@synthesize baseURL;

-(id)init
 {
    self = [super init];
    if (self)
        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SERVER_HOST]];

    return self;
}


- (AFHTTPClient*)client
{
    return [[AFHTTPClient alloc] initWithBaseURL:self.baseURL];
}


- (NSString*) uuidString
{
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef a = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        NSString *uuidString = [NSString stringWithFormat:@"%@",a];
        CFRelease(uuid);
        CFRelease(a);
        return [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}



@end
