//
//  D2Request.h
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
extern NSString *const kDeviceIdentifier;

@protocol D2RequestDelegate <NSObject>
- (void) requestDidError:(NSError*)err;
@end

@interface D2Request : NSObject
@property (nonatomic,weak) NSManagedObjectContext* context;
@property (readonly) AFHTTPClient *client;
@property (nonatomic,retain) NSURL *baseURL;
@property (readonly) NSString* identifier;
@property (readonly) NSString* uuidString;

- (id) initWithContext:(NSManagedObjectContext*)ctx;
- (void) resetIdentifier;

@end
