//
//  Verification.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tick;

@interface Verification : NSManagedObject

@property (nonatomic, retain) NSNumber * enumeration;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * foursquareId;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * wholeNumber;
@property (nonatomic, retain) NSNumber * floatNumber;
@property (nonatomic, retain) NSNumber * verificationId;
@property (nonatomic, retain) Tick *tick;

@end
