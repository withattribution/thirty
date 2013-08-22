//
//  User.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Intent, Like;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *intents;
@property (nonatomic, retain) NSSet *challengesCreated;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *stars;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *followers;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addIntentsObject:(Intent *)value;
- (void)removeIntentsObject:(Intent *)value;
- (void)addIntents:(NSSet *)values;
- (void)removeIntents:(NSSet *)values;

- (void)addChallengesCreatedObject:(NSManagedObject *)value;
- (void)removeChallengesCreatedObject:(NSManagedObject *)value;
- (void)addChallengesCreated:(NSSet *)values;
- (void)removeChallengesCreated:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addStarsObject:(NSManagedObject *)value;
- (void)removeStarsObject:(NSManagedObject *)value;
- (void)addStars:(NSSet *)values;
- (void)removeStars:(NSSet *)values;

- (void)addFollowingObject:(NSManagedObject *)value;
- (void)removeFollowingObject:(NSManagedObject *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addFollowersObject:(NSManagedObject *)value;
- (void)removeFollowersObject:(NSManagedObject *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

@end
