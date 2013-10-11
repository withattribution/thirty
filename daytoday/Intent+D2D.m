//
//  Intent+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Intent+D2D.h"
#import "Challenge+D2D.h"
#import "ChallengeDay+D2D.h"
#import "User+D2D.h"
#import "Tick+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSDate+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Intent"
#define kUniqueIdName @"intentId"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"


@implementation Intent (D2D)
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
    
    Intent *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Intent*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Intent objectWithContext:context];
        [returnObject setIntentId:ident];
    }
    
    return returnObject;
}

+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Intent *u = [Intent getForID:[dictionary valueForKey:@"id"] inContext:context];
    

    return u;
    
}

+(id) fakeIntent:(NSManagedObjectContext*)context
{
    
    Challenge *c = [Challenge fakeChallenge:context];
    c.created_by = [User fakeUser:context];
    Intent* i = [[Intent alloc] initWithContext:context];
    i.challenge = c;
    int startDay = abs(ceil(arc4random() % 40));
    NSTimeInterval seconds = (NSTimeInterval) -1.0*60.0*60.0*24.0*startDay;
    
    NSDate *starting = [NSDate dateWithTimeInterval:seconds sinceDate:[NSDate date]];
    NSTimeInterval thirtyDays = 60.0*60.0*24.0*30.0;
    NSDate *ending = [NSDate dateWithTimeInterval:thirtyDays sinceDate:starting];
    
    [i setStarting:starting];
    [i setEnding:ending];

    NSDate *iteratorDate = starting;
    while( [iteratorDate lessThan:ending] ){
        if( abs(arc4random() % 100) < 50 ){
            ChallengeDay* cd = [[ChallengeDay alloc] initWithContext:context];
            cd.intent = i;
            cd.completed = [NSNumber numberWithBool:YES];
            cd.numberCompleted = [NSNumber numberWithInt:1];
            cd.numberRequired = [NSNumber numberWithInt:1];
            cd.day = iteratorDate;
            Tick *t = [[Tick alloc] initWithContext:context];
            t.createdAt = iteratorDate;
            [t setChallengeDay:cd];
            [t setIntent:i];
            [cd addTicks:[NSSet setWithObject:t]];
            [i addDaysObject:cd];
        }
        iteratorDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:iteratorDate];
    }
    

    
    
    return i;
}
@end
