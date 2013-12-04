//
//  DTConstants.h
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#pragma mark - DTCloudFunctions
// Cloud Functions
extern NSString *const DTQueryActiveDay;

#pragma mark - DTUserDefaults
// Challenge Seed
extern NSString *const kDTChallengeUserSeed;

#pragma mark - DTDateFormatString
// Date Format Constants
extern NSString *const kDTDateFormatNSDateDisplayDay;

#pragma mark - DTNotifications
// Notification Constants
extern NSString *const DTChallengeDayActivityCacheDidRefreshNotification;
extern NSString *const DTChallengeDayRetrievedNotification;

#pragma mark - PFObject Activity Class
// Class Key
extern NSString *const kDTActivityClassKey;

// Field Keys
extern NSString *const kDTActivityFromUserKey;
extern NSString *const kDTActivityToUserKey;
extern NSString *const kDTActivityTypeKey;
extern NSString *const kDTActivityContentKey;
extern NSString *const kDTActivityImageKey;
extern NSString *const kDTActivityChallengeDayKey;
extern NSString *const kDTActivityVerificationKey;

// Type Values
extern NSString *const kDTActivityTypeLike;
extern NSString *const kDTActivityTypeComment;
extern NSString *const kDTActivityTypeFollow;
extern NSString *const kDTActivityTypeChallengeCreation;
extern NSString *const kDTActivityTypeChallengeJoin;
extern NSString *const kDTActivityTypeChallengeFinish;
extern NSString *const kDTActivityTypeVerificationFinish;

#pragma mark - User Class
// Field Keys
extern NSString *const kDTUserDisplayNameKey;
extern NSString *const kDTUserProfileImageKey;
extern NSString *const kDTUserGMTOffset;

#pragma mark - Image Class
// Class Key
extern NSString *const kDTImageClassKey;

// Field Keys
extern NSString *const kDTImageUserKey;
extern NSString *const kDTImageSmallKey;
extern NSString *const kDTImageMediumKey;
extern NSString *const kDTImageTypeKey;

// Type Values
extern NSString *const kDTImageTypeComment;
extern NSString *const kDTImageTypeVerification;
extern NSString *const kDTImageTypeUserChallenge;

#pragma mark - Challenge Day Class
// Class Key
extern NSString *const kDTChallengeDayClassKey;

// Field Keys
extern NSString *const kDTChallengeDayTaskRequiredCountKey;
extern NSString *const kDTChallengeDayTaskCompletedCountKey;
extern NSString *const kDTChallengeDayAccomplishedKey;
extern NSString *const kDTChallengeDayOrdinalDayKey;
extern NSString *const kDTChallengeDayActiveDateKey;
//extern NSString *const kDTChallengeDayIntentKey;

#pragma mark - Cached ChallengeDay Attributes
extern NSString *const kDTChallengeDayAttributeLikeCountKey;
extern NSString *const kDTChallengeDayAttributeCommentCountKey;
extern NSString *const kDTChallengeDayAttributeIsLikedByCurrentUserKey;
extern NSString *const kDTChallengeDayAttributeCommentersKey;
extern NSString *const kDTChallengeDayAttributeLikersKey;

#pragma mark - Intent Class
// Class Key
extern NSString *const kDTIntentClassKey;

// Field Keys
extern NSString *const kDTIntentStartingKey;
extern NSString *const kDTIntentEndingKey;
extern NSString *const kDTIntentUserKey;
extern NSString *const kDTIntentChallengeDays;
extern NSString *const kDTIntentChallengeKey;

#pragma mark - Challenge Class
// Class Key
extern NSString *const kDTChallengeClassKey;

// Field Keys
extern NSString *const kDTChallengeDescriptionKey;
extern NSString *const kDTChallengeDurationKey;
extern NSString *const kDTChallengeFrequencyKey;
extern NSString *const kDTChallengeCategoryKey;
extern NSString *const kDTChallengeNameKey;
extern NSString *const kDTChallengeImageKey;
extern NSString *const kDTChallengeCreatedByKey;
extern NSString *const kDTChallengeVerificationTypeKey;

// Type Values
extern NSString *const kDTChallengeVerificationTypeTick;
extern NSString *const kDTChallengeVerificationTypeTimer;
extern NSString *const kDTChallengeVerificationTypeCheckIn;
extern NSString *const kDTChallengeVerificationTypeImage;

#pragma mark - Verification Class
// Class Key
extern NSString *const kDTVerificationClass;

// Field Keys
extern NSString *const kDTVerificationOrdinalKey;
extern NSString *const kDTVerificationStatusContentKey;
extern NSString *const kDTVerificationImageKey;
extern NSString *const kDTVerificationTimeKey;
extern NSString *const kDTVerificationFoursquareIdKey;





