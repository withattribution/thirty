//
//  ChallengeDay.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Intent, Like, Tick;

@interface ChallengeDay : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * numberCompleted;
@property (nonatomic, retain) NSNumber * numberRequired;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSNumber * challengeDayId;
@property (nonatomic, retain) Intent *intent;
@property (nonatomic, retain) NSSet *ticks;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *comments;
@end

@interface ChallengeDay (CoreDataGeneratedAccessors)

- (void)addTicksObject:(Tick *)value;
- (void)removeTicksObject:(Tick *)value;
- (void)addTicks:(NSSet *)values;
- (void)removeTicks:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
