//
//  UserRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
@protocol UserRequestDelegate <D2RequestDelegate>
- (void) userCreatedSuccesfully;
- (void) gotUser;
- (void) userUpdated;

@end

@interface UserRequest : D2Request
@property(nonatomic,weak) id <UserRequestDelegate> delegate;
- (void) createUser:(NSString*) username withPassword:(NSString*)pw;
- (void) getUser:(NSNumber*)userId;
- (void) updateUserWithParameters:(NSDictionary*)dict;
@end
