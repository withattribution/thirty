//
//  FollowRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/21/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"
#import "User+D2D.h"
#import "Follow+D2D.h"

@protocol FollowRequestDelegate <D2RequestDelegate>
- (void) successfullyFollowed:(Follow*)fl;
- (void) succesfullyUnfollowed;
@end

@interface FollowRequest : D2Request
@property(nonatomic,weak) id <FollowRequestDelegate> delegate;
- (void) followUser:(NSNumber*)userId;
- (void) unfollowUser:(NSNumber*)userId;
@end
