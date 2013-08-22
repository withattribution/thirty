//
//  Tick.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, Intent;

@interface Tick : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Intent *intent;
@property (nonatomic, retain) ChallengeDay *challengeDay;
@property (nonatomic, retain) NSManagedObject *verification;

@end
