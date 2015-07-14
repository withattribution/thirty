//
//  DTCommonRequests+Spec.h
//  daytoday
//
//  Created by peanut on 7/5/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommonRequests (Spec)

//DTCommonRequests used to test User Entry/Exit Intent Retrieval etc

+ (BFTask *)helperRetrievePinnedActiveIntentFromCurrentUser;
+ (BFTask *)helperGetCurrentUserObjectFromService;
+ (BFTask *)helperGetDaysFromLocalStoreForActiveIntent:(PFObject *)intent;

@end
