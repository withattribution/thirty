//
//  User+D2D.h
//  daytoday
//
//  Created by Anderson Miller on 8/20/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "User.h"

@interface User (D2D)
+(id) getForID:(NSNumber*)ident inContext:(NSManagedObjectContext*)context;
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+(id) fakeUser:(NSManagedObjectContext*)context;
+(id) fakeSelfUser:(NSManagedObjectContext*)context;
@end
