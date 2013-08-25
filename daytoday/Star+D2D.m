//
//  Star+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Star+D2D.h"
#import "ChallengeDay+D2D.h"
#import "Challenge+D2D.h"
#import "Intent+D2D.h"
#import "User+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Star"
#define kUniqueIdName @"starId"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"
@implementation Star (D2D)
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
    
    Star *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Star*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Star objectWithContext:context];
        [returnObject setStarId:ident];
    }
    
    return returnObject;
}

+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Star *u = [Star getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    
    return u;
    
}
@end
