//
//  User+D2D.m
//  daytoday
//
//  Created by Anderson Miller on 8/20/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "User+D2D.h"
#import "NSManagedObject+SR.h"
#import "NSManagedObjectContext+SR.h"

#define kEntityName @"User"
#define kUniqueIdName @"user_id"
#define kUsernameKey @"username"
#define kBioKey @"bio"
#define kWebsiteKey @"website"
#define kRealNameKey @"real_name"
#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"

@implementation User (D2D)
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
    
    User *returnObject = nil;
    
    if([returnObjects count] > 0){
        returnObject = (User*)[returnObjects objectAtIndex:0];
    }else{
        returnObject = [User objectWithContext:context];
        [returnObject setUser_id:ident];
    }

    return returnObject;
}

+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context
{
    User *u = [User getForID:[dictionary valueForKey:@"id"] inContext:context];
    
    if( [dictionary valueForKey:kUsernameKey] )
        [u setUsername:[dictionary valueForKey:kUsernameKey]];

    if( [dictionary validKey:kRealNameKey] )
        [u setReal_name:[dictionary valueForKey:kRealNameKey]];
    
    if( [dictionary validKey:kBioKey])
        [u setBio:[dictionary valueForKey:kBioKey]];
    
    if( [dictionary validKey:kWebsiteKey])
        [u setWebsite:[dictionary valueForKey:kWebsiteKey]];
    
    return u;
        
}
@end
