//
//  DTConstants.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTConstants.h"

#pragma mark - Activity Class
// Class Key
NSString *const kDTActivityClassKey                    =@"Activity";

// Field Keys
NSString *const kDTActivityFromUserKey                 =@"fromUser";
NSString *const kDTActivityToUserKey                   =@"toUser";
NSString *const kDTActivityTypeKey                     =@"type";
NSString *const kDTActivityContentKey                  =@"content";
NSString *const kDTActivityImageKey                    =@"image";
NSString *const kDTActivityChallengeDayKey             =@"challengeDay";

// Type Values
NSString *const kDTActivityTypeLike                    =@"like";
NSString *const kDTActivityTypeComment                 =@"comment";
NSString *const kDTActivityTypeFollow                  =@"follow";
NSString *const kDTActivityTypeChallengeCreation       =@"challengeCreation";
NSString *const kDTActivityTypeChallengeJoin           =@"challengeJoin";
NSString *const kDTActivityTypeChallengeFinish         =@"challengeFinish";
NSString *const kDTActivityTypeVerificationFinish      =@"verificationFinish";

#pragma mark - User Class
// Field Keys
NSString *const kDTUserDisplayNameKey                  =@"displayName";
NSString *const kDTUserProfileImageKey                 =@"profileImage";

#pragma mark - Image Class
// Class Key
NSString *const kDTImageClassKey                       =@"Image";

// Field Keys
NSString *const kDTImageUserKey                        =@"user";
NSString *const kDTImageSmallKey                       =@"small";
NSString *const kDTImageMediumKey                      =@"medium";
NSString *const kDTImageTypeKey                        =@"type";

// Type Values
NSString *const kDTImageTypeComment                    =@"commentImage";
NSString *const kDTImageTypeVerification               =@"verificationImage";
NSString *const kDTImageTypeUserChallenge              =@"challengeImage";

#pragma mark - Challenge Day Class
// Class Key
NSString *const kDTChallengeDayClassKey                =@"ChallengeDay";

// Field Keys
NSString *const kDTChallengeDayTaskRequiredCountKey    =@"required";
NSString *const kDTChallengeDayTaskCompletedCountKey   =@"completed";
NSString *const kDTChallengeDayAccomplishedKey         =@"accomplished";
NSString *const kDTChallengeDayOrdinalDayKey           =@"ordinal";
NSString *const kDTChallengeDayIntentKey               =@"intent";

#pragma mark - Intent Class
// Class Key
NSString *const kDTIntentClassKey                      =@"Intent";

// Field Keys
NSString *const kDTIntentStartingKey                   =@"start";
NSString *const kDTIntentEndingKey                     =@"end";
NSString *const kDTIntentUserKey                       =@"user";

#pragma mark - Challenge Class
// Class Key
NSString *const kDTChallengeClassKey                   =@"Challenge";

// Field Keys
NSString *const kDTChallengeDescriptionKey             =@"desc";
NSString *const kDTChallengeDurationKey                =@"duration";
NSString *const kDTChallengeFrequencyKey               =@"freq";
NSString *const kDTChallengeCategoryKey                =@"cat";
NSString *const kDTChallengeNameKey                    =@"name";
NSString *const kDTChallengeImageKey                   =@"image";

#pragma mark - Cached ChallengeDay Attributes
NSString *const kDTChallengeDayAttributeLikeCountKey            =@"likes";
NSString *const kDTChallengeDayAttributeCommentCountKey         =@"comments";
NSString *const kDTChallengeDayAttributeIsLikedByCurrentUserKey =@"liked";

















