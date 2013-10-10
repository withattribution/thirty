//
//  Challenge.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Intent, User;

@interface Challenge : NSManagedObject

@property (nonatomic, retain) NSNumber * challengeId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) User *created_by;
@property (nonatomic, retain) NSSet *image;
@property (nonatomic, retain) NSSet *intents;
@end

@interface Challenge (CoreDataGeneratedAccessors)

- (void)addImageObject:(Image *)value;
- (void)removeImageObject:(Image *)value;
- (void)addImage:(NSSet *)values;
- (void)removeImage:(NSSet *)values;

- (void)addIntentsObject:(Intent *)value;
- (void)removeIntentsObject:(Intent *)value;
- (void)addIntents:(NSSet *)values;
- (void)removeIntents:(NSSet *)values;

@end
