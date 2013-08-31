//
//  Comment+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Comment+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Comment"
#define kUniqueIdName @"commentId"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"
@implementation Comment (D2D)
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
    
    Comment *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Comment*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Comment objectWithContext:context];
        [returnObject setCommentId:ident];
    }
    
    return returnObject;
}

+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    Comment *u = [Comment getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    if( [dictionary validKey:kCreatedAtKey] )
        [u setCreatedAt:[NSDate fromString:[dictionary valueForKey:kCreatedAtKey]]];
    return u;
    
}
@end
