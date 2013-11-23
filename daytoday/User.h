//
//  User.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Challenge, Comment, Follow, Image, Intent, Like, Star;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *challengesCreated;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *following;
@property (nonatomic, retain) NSSet *image;
@property (nonatomic, retain) NSSet *intents;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *stars;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addChallengesCreatedObject:(Challenge *)value;
- (void)removeChallengesCreatedObject:(Challenge *)value;
- (void)addChallengesCreated:(NSSet *)values;
- (void)removeChallengesCreated:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addFollowersObject:(Follow *)value;
- (void)removeFollowersObject:(Follow *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFollowingObject:(Follow *)value;
- (void)removeFollowingObject:(Follow *)value;
- (void)addFollowing:(NSSet *)values;
- (void)removeFollowing:(NSSet *)values;

- (void)addImageObject:(Image *)value;
- (void)removeImageObject:(Image *)value;
- (void)addImage:(NSSet *)values;
- (void)removeImage:(NSSet *)values;

- (void)addIntentsObject:(Intent *)value;
- (void)removeIntentsObject:(Intent *)value;
- (void)addIntents:(NSSet *)values;
- (void)removeIntents:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addStarsObject:(Star *)value;
- (void)removeStarsObject:(Star *)value;
- (void)addStars:(NSSet *)values;
- (void)removeStars:(NSSet *)values;

@end
