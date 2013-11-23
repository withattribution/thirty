//
//  TickRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/25/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"
#import "Tick+D2D.h"
#import "ChallengeDay+D2D.h"

@protocol TickRequestDelegate <D2RequestDelegate>
- (void) tickAccepted:(ChallengeDay*)cd andTick:(Tick*)t;
@end

@interface TickRequest : D2Request

@property (nonatomic,weak) id <TickRequestDelegate> delegate;

- (void) makeTick:(NSDictionary*)params;

@end
