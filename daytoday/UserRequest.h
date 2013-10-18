//
//  UserRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "D2Request.h"
#import "User+D2D.h"

@protocol UserRequestDelegate <D2RequestDelegate>
- (void) userCreatedSuccesfully:(User*)user;
- (void) gotUser:(User*)user;
- (void) userUpdated:(User*)user;

@end

@interface UserRequest : D2Request
@property(nonatomic,weak) id <UserRequestDelegate> delegate;

- (void) createUser:(NSString*) facebookAuthToken;
- (void) createUser:(NSString*) username withPassword:(NSString*)pw additionalParameters:(NSDictionary*)dict;
- (void) getUser:(NSNumber*)userId;
- (void) updateUserWithParameters:(NSDictionary*)dict;
@end
