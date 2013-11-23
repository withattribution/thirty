//
//  ProfileRequest.h
//  daytoday
//
//  Created by Anderson Miller on 9/9/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"
@protocol ProfileRequestDelegate <D2RequestDelegate>
- (void) gotProfile:(NSDictionary*)dict;
@end

@interface ProfileRequest : D2Request
@property(nonatomic,weak) id <ProfileRequestDelegate> delegate;
- (void) getMyProfile;
- (void) getProfileForUser:(NSNumber*)userId;
@end
