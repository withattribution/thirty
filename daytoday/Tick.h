//
//  Tick.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChallengeDay, Intent, Verification;

@interface Tick : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * tickId;
@property (nonatomic, retain) ChallengeDay *challengeDay;
@property (nonatomic, retain) Intent *intent;
@property (nonatomic, retain) Verification *verification;

@end
