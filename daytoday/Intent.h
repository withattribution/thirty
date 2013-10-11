//
//  Intent.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Challenge, ChallengeDay, User;

@interface Intent : NSManagedObject

@property (nonatomic, retain) NSDate * ending;
@property (nonatomic, retain) NSNumber * intentId;
@property (nonatomic, retain) NSDate * starting;
@property (nonatomic, retain) Challenge *challenge;
@property (nonatomic, retain) NSSet *days; //Days participated
@property (nonatomic, retain) User *user;
@end

@interface Intent (CoreDataGeneratedAccessors)

- (void)addDaysObject:(ChallengeDay *)value;
- (void)removeDaysObject:(ChallengeDay *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
