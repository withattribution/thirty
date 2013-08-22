//
//  Challenge+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Challenge+D2D.h"
#import "User+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Challenge"
#define kUniqueIdName @"challengeId"
#define kDescriptionKey @"description"
#define kDurationKey @"duration"
#define kFrequencyKey @"frequency"
#define kNameKey @"name"
#define kCreatedByKey @"created_by"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"
@implementation Challenge (D2D)

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
    
    Challenge *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Challenge*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Challenge objectWithContext:context];
        [returnObject setChallengeId:ident];
    }
    
    return returnObject;
}
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Challenge *u = [Challenge getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    if( [dictionary validKey:kNameKey] )
        [u setName:[dictionary valueForKey:kNameKey]];
    
    if( [dictionary validKey:kDescriptionKey] )
        [u setDesc:[dictionary valueForKey:kDescriptionKey]];
    
    if( [dictionary validKey:kDurationKey] )
        [u setDuration:[dictionary valueForKey:kDurationKey]];
    
    if( [dictionary validKey:kFrequencyKey] )
        [u setFrequency:[dictionary valueForKey:kFrequencyKey]];
    
    if( [dictionary validKey:kCreatedByKey] )
        [u setCreated_by:[User getForID:[dictionary valueForKey:kCreatedByKey] inContext:context]];
    
    return u;
    
}
@end
