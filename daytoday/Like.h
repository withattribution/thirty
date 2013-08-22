//
//  Like.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, User;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * likeId;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) ChallengeDay *challengeDay;

@end
