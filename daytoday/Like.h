//
//  Like.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, User;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * likeId;
@property (nonatomic, retain) ChallengeDay *challengeDay;
@property (nonatomic, retain) User *user;

@end
