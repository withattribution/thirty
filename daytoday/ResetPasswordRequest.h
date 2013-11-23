//
//  ResetPasswordRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/26/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"

@protocol ResetPasswordDelegate <D2RequestDelegate>
- (void) passwordResetSuccessful;
@end

@interface ResetPasswordRequest : D2Request
@property(nonatomic,weak) id <ResetPasswordDelegate> delegate;
- (void) resetPassword:(NSString*)oldPassword newPassword:(NSString*)np;
@end
