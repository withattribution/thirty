//
//  Like+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Like+D2D.h"
#import "User+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"Like"
#define kUniqueIdName @"likeId"

#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"


@implementation Like (D2D)
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
    
    Like *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (Like*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [Like objectWithContext:context];
        [returnObject setLikeId:ident];
    }
    
    return returnObject;
}
@end
