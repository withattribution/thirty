//
//  Comment.h
//  daytoday
//
//  Created by Anderson Miller on 8/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, Image, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) ChallengeDay *challengeDay;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Image *image;

@end
