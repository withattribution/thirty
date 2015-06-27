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

+ (void)joinChallenge:(NSString *)challengeId;

#pragma mark Intents for User

+ (void)setCurrentUserActiveIntent:(PFObject *)intent;
+ (void)queryIntentsForUser:(PFUser *)user;
+ (BFTask *)queryActiveIntentForUser:(PFUser *)user __attribute__((deprecated("use retrieveIntentForUser:user instead")));
+ (BFTask *)retrieveIntentForUser:(PFUser *)user;

+ (PFQuery *)queryForActivitiesOnChallengeDay:(PFObject *)challengeDay cachePolicy:(PFCachePolicy)cachePolicy;

#pragma mark Verification Activity Request

+ (void)verificationActivity:(NSString *)status;
+ (void)refreshActiveChallengeDay;

#pragma mark User Entry/Exit

+ (void)logoutCurrentUser;
+ (void)logInWithUserCredential:(NSString *)userCredential password:(NSString *)passwordCredential;
+ (void)signUpWithEmailCredential:(NSString *)emailCredential password:(NSString *)passwordCredential user:(NSString *)userCredential;


@end