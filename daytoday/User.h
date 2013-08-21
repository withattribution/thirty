//
//  User.h
//  daytoday
//
//  Created by Anderson Miller on 8/20/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * real_name;
@property (nonatomic, retain) NSNumber * user_id;

@end
