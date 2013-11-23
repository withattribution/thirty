//
//  Intent+D2D.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Intent.h"

@interface Intent (D2D)
+(id) getForID:(NSNumber*)ident inContext:(NSManagedObjectContext*)context;
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+(id) fakeIntent:(NSManagedObjectContext*)context;

- (NSInteger)daysLeft;
- (NSString *)monthSpan;
- (CGFloat)percentCompleted;

@end
