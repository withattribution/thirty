//
//  FakeDataUtils.m
//  daytoday
//
//  Created by Anderson Miller on 10/6/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "FakeDataUtils.h"

@implementation FakeDataUtils

+(NSString*) uuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef a = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *uuidString = [NSString stringWithFormat:@"%@",a];
    CFRelease(uuid);
    CFRelease(a);
    return [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+(NSNumber*) randomNumber
{
    srand([[NSDate date] timeIntervalSince1970]);
    int a = ceil((rand()%10000)+10000);
    return [NSNumber numberWithInt:a];
}

@end
