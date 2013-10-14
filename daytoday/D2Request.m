//
//  D2Request.m
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"


NSString *const kDeviceIdentifier = @"com.submarinerich.daytoday.deviceidentifier";

@implementation D2Request
@synthesize baseURL, context;

-(id)init
 {
    self = [super init];
    if (self)
        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",SERVER_HOST]];

     //NIDINFO(@"base URL:%@",self.baseURL);
    return self;
}


- (id) initWithContext:(NSManagedObjectContext*)ctx
{
    self = [self init];
    if( self )
        self.context = ctx;
    
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

- (NSString*) identifier
{
    if([[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifier] == nil ){
        [[NSUserDefaults standardUserDefaults] setValue:[self uuidString] forKey:kDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return (NSString*)[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifier];
}

-(NSString*) pushIdentifier
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] valueForKey:@"kUADeviceToken"];
}


- (void) resetIdentifier
{
    NSString *k = @"kUADeviceToken";
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kDeviceIdentifier];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:k];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
