//
//  Image.h
//  daytoday
//
//  Created by Anderson Miller on 8/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Challenge, Comment, User, Verification;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * local;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Challenge *challenge;
@property (nonatomic, retain) Verification *verification;
@property (nonatomic, retain) Comment *comment;

@end
