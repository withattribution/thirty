//
//  DTConstants.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTConstants.h"

//@implementation DTConstants

#pragma mark - Activity Class
// Class Key
NSString *const kDTActivityClassKey                  =@"Activity";

// Field Keys
NSString *const kDTActivityFromUserKey              =@"fromUser";
NSString *const kDTActivityToUserKey                =@"toUser";
NSString *const kDTActivityTypeKey                  =@"type";
NSString *const kDTActivityContentKey               =@"content";
NSString *const kDTActivityImageKey                 =@"image";
NSString *const kDTActivityChallengeDayKey          =@"challengeDay";

// Type Values
NSString *const kDTActivityTypeLike                 =@"like";
NSString *const kDTActivityTypeComment              =@"comment";
NSString *const kDTActivityTypeFollow               =@"follow";
NSString *const kDTActivityTypeChallengeCreation    =@"challengeCreation";
NSString *const kDTActivityTypeChallengeJoin        =@"challengeJoin";
NSString *const kDTActivityTypeChallengeFinish      =@"challengeFinish";
NSString *const kDTActivityVerificationFinish       =@"verificationFinish";

#pragma mark - User Class
// Field Keys
NSString *const kDTUserDisplayNameKey               =@"displayName";
NSString *const kDTUserProfileImageKey              =@"profileImage";

#pragma mark - Image Class
// Class Key
NSString *const kDTImageClassKey                    =@"image";

// Field Keys
NSString *const kDTImageUserKey                     =@"userImage";
NSString *const kDTImageCommentKey                  =@"commentImage";
NSString *const kDTImageVerificationKey             =@"verificationImage";
NSString *const kDTImageUserChallengeKey            =@"challengeImage";
NSString *const kDTImageSizeSmallKey                   =@"small";
NSString *const kDTImageSizeMediumKey                  =@"medium";


//@end
