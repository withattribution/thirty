//
//  Intent+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Intent+D2D.h"
#import "Challenge+D2D.h"
#import "User+D2D.h"
#import "NSManagedObject+SR.h"
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
@end
