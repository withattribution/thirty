//
//  DTConstants.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTConstants.h"

#pragma mark - Activity Class
// Class Key
NSString *const kDTActivityClassKey                 =@"Activity";

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
NSString *const kDTImageUserKey                     =@"user";
NSString *const kDTImageSmallKey                    =@"small";
NSString *const kDTImageMediumKey                   =@"medium";
NSString *const kDTImageTypeKey                     =@"type";

// Type Values
NSString *const kDTImageTypeComment                 =@"commentImage";
NSString *const kDTImageTypeVerification            =@"verificationImage";
NSString *const kDTImageTypeUserChallenge           =@"challengeImage";
