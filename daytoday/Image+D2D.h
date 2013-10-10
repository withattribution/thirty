//
//  Image+D2D.h
//  daytoday
//
//  Created by Anderson Miller on 8/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Image.h"
extern NSString *const kImageSmallTag;
extern NSString *const kImageMediumTag;
extern NSString *const kImageLargeTag;
@interface Image (D2D)
+(id) getForID:(NSNumber*)ident inContext:(NSManagedObjectContext*)context;
+(id) fromDictionary:(NSDictionary*)dictionary inContext:(NSManagedObjectContext*)context;
+(id) imageWithURL:(NSString*)url andContext:(NSManagedObjectContext *)context;
@end
