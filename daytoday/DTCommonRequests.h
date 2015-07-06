//
//  DTRequests.h
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommonRequests : NSObject

+ (void)likeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unLikeChallengeDayInBackGround:(PFObject *)challengeDay block:(void(^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)activeDayForDate:(NSDate *)date user:(PFUser *)user;

+ (void)requestDaysForIntent:(PFObject *)intent cachePolicy:(PFCachePolicy)cachePolicy;

#pragma mark Verification Activity Request

+ (void)verificationActivity:(NSString *)status;
+ (void)refreshActiveChallengeDay;
+ (PFQuery *)queryForActivitiesOnChallengeDay:(PFObject *)challengeDay cachePolicy:(PFCachePolicy)cachePolicy;

#pragma mark Intents for User

/*!
 An active intent is pinned if it belongs to the current user
 *** otherwise ***
 all intents are either cached, available on service, or empty
*/

+ (BFTask *)retrieveActiveIntentForUser:(PFUser *)user;
+ (BFTask *)retrieveIntentsForUser:(PFUser *)user;

#pragma mark Challenge Entry/Exit

+ (BFTask *)joinChallenge:(NSString *)challengeId;
+ (BFTask *)leaveChallenge;

#pragma mark User Entry/Exit

+ (BFTask *)logoutCurrentUser;
+ (BFTask *)logInWithUserCredential:(NSString *)userCredential password:(NSString *)passwordCredential;
+ (void)signUpWithEmailCredential:(NSString *)emailCredential password:(NSString *)passwordCredential user:(NSString *)userCredential;

@end