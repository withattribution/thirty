//
//  Follow.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Follow : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * followId;
@property (nonatomic, retain) User *follower;
@property (nonatomic, retain) User *superstar;

@end
