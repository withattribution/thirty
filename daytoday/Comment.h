//
//  Comment.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, Image, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) ChallengeDay *challengeDay;
@property (nonatomic, retain) NSSet *image;
@property (nonatomic, retain) User *user;
@end

@interface Comment (CoreDataGeneratedAccessors)

- (void)addImageObject:(Image *)value;
- (void)removeImageObject:(Image *)value;
- (void)addImage:(NSSet *)values;
- (void)removeImage:(NSSet *)values;

@end
