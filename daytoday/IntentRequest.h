//
//  IntentRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
#import "Intent+D2D.h"

@protocol IntentRequestDelegate <D2RequestDelegate>
- (void) createdIntent:(Intent*)challenge;
- (void) deletedIntent:(Intent*)challenge;
@end

@interface IntentRequest : D2Request
@property(nonatomic,weak) id <IntentRequestDelegate> delegate;

- (void) createIntent:(NSDictionary*)params;
- (void) deleteIntent:(NSNumber*)intentId;

@end
