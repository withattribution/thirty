//
//  Verification.h
//  daytoday
//
//  Created by Anderson Miller on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Tick;

@interface Verification : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * enumeration;
@property (nonatomic, retain) NSNumber * floatNumber;
@property (nonatomic, retain) NSNumber * foursquareId;
@property (nonatomic, retain) NSNumber * verificationId;
@property (nonatomic, retain) NSNumber * wholeNumber;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) Tick *tick;

@end
