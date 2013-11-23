//
//  Comment+D2D.h
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Comment.h"

@interface Comment (D2D)
+(id) getForID:(NSNumber*)ident inContext:(NSManagedObjectContext*)context;
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
@end
