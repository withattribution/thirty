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
extern NSString *const DTJoinChallenge;

#pragma mark - DTUserDefaults
// Challenge Seed
extern NSString *const kDTChallengeUserSeed;
extern NSString *const kDTActiveIntent;

#pragma mark - DTDateFormatString
// Date Format Constants
extern NSString *const kDTDateFormatNSDateDisplayDay;
extern NSString *const kDTDateFormatNSDateDisplayForSeed;

#pragma mark - DTNotifications
// Notification Constants
extern NSString *const DTChallengeDayActivityCacheDidRefreshNotification;
extern NSString *const DTChallengeDayRetrievedNotification;

extern NSString *const DTChallengeDayDidCacheDaysForIntentNotification;
extern NSString *const DTChallengeDayDidCacheDayNotification;

extern NSString *const DTIntentDidCacheIntentsForUserNotification;
extern NSString *const DTIntentDidCacheIntentForUserNotification;

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
extern NSString *const kDTActivityTypeChallengeDayFinish;
extern NSString *const kDTActivityTypeVerificationFinish;

#pragma mark - User Class
// Field Keys
extern NSString *const kDTUserDisplayNameKey;
extern NSString *const kDTUserActiveIntent;
extern NSString *const kDTUserProfileImageKey;
extern NSString *const kDTUserGMTOffset;
//extern NSString *const kDTUserIntents;

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
extern NSString *const kDTChallengeDayActiveHashKey;
//extern NSString *const kDTChallengeDayIntentKey;

#pragma mark - Cached ChallengeDay ACTIVITY Attributes
#warning need to make these explicitly ACTIVITY ATTRIBUTES
// Cached Attributes
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
extern NSString *const kDTIntentAccomplishedIntentKey;
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
extern NSUInteger const kDTChallengeVerificationTypeTick;
extern NSUInteger const kDTChallengeVerificationTypeCheckIn;
extern NSUInteger const kDTChallengeVerificationTypeImage;
extern NSUInteger const kDTChallengeVerificationTypeTimer;

#pragma mark - Verification Class
// Class Key
extern NSString *const kDTVerificationClass;

// Field Keys
extern NSString *const kDTVerificationOrdinalKey;
extern NSString *const kDTVerificationStatusContentKey;
extern NSString *const kDTVerificationImageKey;
extern NSString *const kDTVerificationTimeKey;
extern NSString *const kDTVerificationFoursquareIdKey;
extern NSString *const kDTVerificationTypeKey;

// Type Values
extern NSUInteger const kDTVerificationTypeTick;
extern NSUInteger const kDTVerificationTypeCheckIn;
extern NSUInteger const kDTVerificationTypeImage;
extern NSUInteger const kDTVerificationTypeTimer;




