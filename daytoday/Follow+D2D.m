//
//  Follow+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Follow+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"
#import "User+D2D.h"

#define kEntityName @"Follow"
#define kUniqueIdName @"followId"
#define kSuperstarKey @"superstar"
#define kFollowerKey @"follower"
#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"

@implementation Follow (D2D)

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
    
    Follow *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Follow*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Follow objectWithContext:context];
        [returnObject setFollowId:ident];
    }
    
    return returnObject;
}

+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Follow *u = [Follow getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    if( [dictionary valueForKey:kSuperstarKey] )
        [u setSuperstar:[User getForID:[dictionary valueForKey:kSuperstarKey] inContext:context]];
    
    if( [dictionary valueForKey:kFollowerKey] )
        [u setFollower:[User getForID:[dictionary valueForKey:kFollowerKey] inContext:context]];
    
    if( [dictionary validKey:kCreatedAtKey] )
        [u setCreatedAt:[NSDate fromString:[dictionary valueForKey:kCreatedAtKey]]];
    
    return u;
}
@end
