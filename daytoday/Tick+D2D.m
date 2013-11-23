//
//  Tick+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "Tick+D2D.h"
#import "ChallengeDay+D2D.h"
#import "User+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Tick"
#define kUniqueIdName @"tickId"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"

@implementation Tick (D2D)
+(id) getForID:(NSNumber*)ident inContext:(NSManagedObjectContext*)context
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"%@=%@",kUniqueIdName,ident];
    request.fetchLimit = 1; //!< if it's returning over one, there's a problem
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *returnObjects = [context executeFetchRequest:request error:&error];
    
    Tick *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Tick*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Tick objectWithContext:context];
        [returnObject setTickId:ident];
    }
    
    return returnObject;
}
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Tick *u = [Tick getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    if( [dictionary validKey:kCreatedAtKey] )
        [u setCreatedAt:[NSDate fromString:[dictionary valueForKey:kCreatedAtKey]]];
    return u;
    
}
@end
