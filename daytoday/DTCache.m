//
//  DTCache.m
//  daytoday
//
//  Created by Alberto Tafoya on 11/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Parse/Parse.h>
#import "DTCache.h"

@interface DTCache ()

@property (strong,nonatomic) NSCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forChallengeDay:(PFObject *)challengeDay;

@end

@implementation DTCache

+ (id)sharedCache
{
  static dispatch_once_t pred = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&pred, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

- (id)init
{
  self = [super init];
  if (self) {
    self.cache = [[NSCache alloc] init];
  }
  return self;
}

- (void)clear
{
  [self.cache removeAllObjects];
}

#pragma mark - Challenge For Intent

- (void)cacheChallenge:(PFObject *)challenge forIntent:(PFObject *)intent
{
  NSString *key = [self keyForChallenge:intent];
  [self.cache setObject:challenge forKey:key];
}

- (PFObject *)challengeForIntent:(PFObject *)intent
{
  NSString *key = [self keyForChallenge:intent];
  return [self.cache objectForKey:key];
}

- (NSString *)keyForChallenge:(PFObject *)intent
{
  return [NSString stringWithFormat:@"challenge_%@",[[intent objectForKey:kDTIntentChallengeKey] objectId]];
}

- (void)cacheChallengeDay:(PFObject *)challengeDay
{
  NSString *key = [self keyForChallengeDay:challengeDay];
  [self.cache setObject:challengeDay forKey:key];
  
  [[NSNotificationCenter defaultCenter]
          postNotificationName:DTChallengeDayDidCacheDayNotification
          object:challengeDay
          userInfo:nil];
}

#pragma mark - ChallengeDay Activity Cache

- (void)refreshCacheActivity:(NSArray *)activities forChallengeDay:(PFObject *)challengeDay
{
  NSMutableArray *likers = [NSMutableArray array];
  NSMutableArray *commenters = [NSMutableArray array];

  BOOL isLikedByCurrentUser = NO;
  
  for (PFObject *activity in activities) {
    if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeComment]
        && [activity objectForKey:kDTActivityFromUserKey])
    {
      [commenters addObject:[activity objectForKey:kDTActivityFromUserKey]];
    }else if ([[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike]
              && [activity objectForKey:kDTActivityFromUserKey])
    {
      [likers addObject:[activity objectForKey:kDTActivityFromUserKey]];
    }
    if ([[[activity objectForKey:kDTActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]
        && [[activity objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeLike])
    {
      isLikedByCurrentUser = YES;
    }
  }
  [self setAttributesForChallengeDay:challengeDay
                              likers:likers
                          commenters:commenters
                isLikedByCurrentUser:isLikedByCurrentUser];
  
  [[NSNotificationCenter defaultCenter]
      postNotificationName:DTChallengeDayActivityCacheDidRefreshNotification
                    object:challengeDay
                  userInfo:[NSDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]]];
}

#pragma mark - Challenge Day For Date

- (PFObject *)challengeDayForDate:(NSDate *)date intent:(PFObject *)intent
{
  uint32_t dayHash = [DTCommonUtilities dayHashFromDate:date intent:intent];
//  NIDINFO(@"dayHash: %u",dayHash);

  PFObject *chDayForDate = nil;
  NSArray *challengeDays = [self challengeDaysForIntent:intent];
  
  for (int i = 0; i < [challengeDays count]; i++) {
    if ([[[challengeDays objectAtIndex:i] objectForKey:kDTChallengeDayActiveHashKey] unsignedIntValue] == dayHash)
    {
      chDayForDate = [challengeDays objectAtIndex:i];
      break;
    }
  }
  
  return chDayForDate;
}

#pragma mark - Challenge Days For Intent

- (void)cacheChallengeDays:(NSArray *)days forIntent:(PFObject *)intent
{
  [self setChallengeDays:days forIntent:intent];
  
  [[NSNotificationCenter defaultCenter]
   postNotificationName:DTChallengeDayDidCacheDaysForIntentNotification
   object:days
   userInfo:nil];
}

- (NSArray *)challengeDaysForIntent:(PFObject *)intent
{
  NSString *key = [self keyForIntent:intent];
  return [self.cache objectForKey:key];
}

- (void)removeChallengeDaysForCurrentUser
{
  NSString *key = [self keyForIntent:[self activeIntentForUser:[PFUser currentUser]]];
  return [self.cache removeObjectForKey:key];
}

#pragma mark - Intents for User

- (PFObject *)activeIntentForUser:(PFUser *)user
{
  NSString *key = [self keyForActiveIntent:user];
  return [self.cache objectForKey:key];
}

- (void)cacheActiveIntent:(PFObject *)intent user:(PFUser *)user
{
  [self setActiveIntent:intent user:user];
  [self cacheIntent:intent forUser:user];
}

- (void)removeActiveIntentForCurrentUser
{
  NSMutableArray *intents = [NSMutableArray arrayWithArray:[self intentsForUser:[PFUser currentUser]]];
  [intents removeObject:[self activeIntentForUser:[PFUser currentUser]]];
  [self setIntents:intents forUser:[PFUser currentUser]];

  NSString *key = [self keyForActiveIntent:[PFUser currentUser]];
  [self.cache removeObjectForKey:key];
}

- (void)cacheIntent:(PFObject *)intent forUser:(PFUser *)user
{
  NSMutableArray *intents = [NSMutableArray arrayWithArray:[self intentsForUser:user]];
  [intents addObject:intent];
  [self setIntents:intents forUser:user];
  
  [[NSNotificationCenter defaultCenter]
    postNotificationName:DTIntentDidCacheIntentForUserNotification
                  object:intent
                userInfo:nil];
}

- (void)cacheIntents:(NSArray *)intents forUser:(PFUser *)user
{
  [self setIntents:intents forUser:user];
  
  [[NSNotificationCenter defaultCenter]
    postNotificationName:DTIntentDidCacheIntentsForUserNotification
                  object:intents
                userInfo:nil];
}

- (NSArray *)intentsForUser:(PFUser *)user
{
  NSString *key = [self keyForUser:user];
  return [self.cache objectForKey:key];
}

#pragma mark - Comment And Like Get Methods

- (NSNumber *)likeCountForChallengeDay:(PFObject *)challengeDay
{
  NSDictionary *attributes = [self attributesForChallengeDay:challengeDay];
  if (attributes) {
    return [attributes objectForKey:kDTChallengeDayAttributeLikeCountKey];
  }
  return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForChallengeDay:(PFObject *)challengeDay
{
  NSDictionary *attributes = [self attributesForChallengeDay:challengeDay];
  if (attributes) {
    return [attributes objectForKey:kDTChallengeDayAttributeCommentCountKey];
  }
  return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForChallengeDay:(PFObject *)challengeDay
{
  NSDictionary *attributes = [self attributesForChallengeDay:challengeDay];
  if (attributes) {
    return [attributes objectForKey:kDTChallengeDayAttributeLikersKey];
  }
  return [NSArray array];
}

- (NSArray *)commentersForChallengeDay:(PFObject *)challengeDay
{
  NSDictionary *attributes = [self attributesForChallengeDay:challengeDay];
  if (attributes) {
    return [attributes objectForKey:kDTChallengeDayAttributeCommentersKey];
  }
  return [NSArray array];
}

- (void)setChallengeDayIsLikedByCurrentUser:(PFObject *)challengeDay liked:(BOOL)liked
{
  NSNumber *isLiked = [NSNumber numberWithBool:liked];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]];
  [attributes setObject:isLiked forKey:kDTChallengeDayAttributeIsLikedByCurrentUserKey];
  [self setAttributes:attributes forChallengeDay:challengeDay];
}

- (BOOL)isChallengeDayLikedByCurrentUser:(PFObject *)challengeDay
{
  NSDictionary *attributes = [self attributesForChallengeDay:challengeDay];
  if (attributes) {
    return [[attributes objectForKey:kDTChallengeDayAttributeIsLikedByCurrentUserKey] boolValue];
  }
  return NO;
}

#pragma mark - Comment Caching Methods

- (void)incrementCommentCountForChallengeDay:(PFObject *)challengeDay
{
  NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForChallengeDay:challengeDay] intValue] + 1];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]];
  [attributes setObject:commentCount forKey:kDTChallengeDayAttributeCommentCountKey];
  [self setAttributes:attributes forChallengeDay:challengeDay];
}

- (void)decrementCommentCountForChallengeDay:(PFObject *)challengeDay
{
  NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForChallengeDay:challengeDay] intValue] - 1];
  if ([commentCount intValue] < 0) {
    return;
  }
  NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]];
  [attributes setObject:commentCount forKey:kDTChallengeDayAttributeCommentCountKey];
  [self setAttributes:attributes forChallengeDay:challengeDay];
}

#pragma mark - Like Caching Methods 

- (void)incrementLikeCountForChallengeDay:(PFObject *)challengeDay
{
  NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForChallengeDay:challengeDay] intValue] + 1];
  NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]];
  [attributes setObject:likeCount forKey:kDTChallengeDayAttributeLikeCountKey];
  [self setAttributes:attributes forChallengeDay:challengeDay];
}

- (void)decrementLikeCountForChallengeDay:(PFObject *)challengeDay
{
  NSNumber *likeCount = [NSNumber numberWithInt:[[self likeCountForChallengeDay:challengeDay] intValue] - 1];
  if ([likeCount intValue] < 0) {
    return;
  }
  NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForChallengeDay:challengeDay]];
  [attributes setObject:likeCount forKey:kDTChallengeDayAttributeLikeCountKey];
  [self setAttributes:attributes forChallengeDay:challengeDay];
}

- (void)setAttributesForChallengeDay:(PFObject *)challengeDay
                              likers:(NSArray *)likers
                          commenters:(NSArray *)commenters
                isLikedByCurrentUser:(BOOL)liked
{
  NSDictionary *attributes = @{kDTChallengeDayAttributeLikeCountKey:@([likers count]),
                            kDTChallengeDayAttributeCommentCountKey:@([commenters count]),
                    kDTChallengeDayAttributeIsLikedByCurrentUserKey:@(liked),
                              kDTChallengeDayAttributeCommentersKey:commenters,
                                  kDTChallengeDayAttributeLikersKey:likers};

  [self setAttributes:attributes forChallengeDay:challengeDay];
}

- (NSDictionary *)attributesForChallengeDay:(PFObject *)challengeDay
{
  NSString *key = [self keyForChallengeDay:challengeDay];
  return [self.cache objectForKey:key];
}

#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forChallengeDay:(PFObject *)challengeDay
{
  NSString *key = [self keyForChallengeDay:challengeDay];
  [self.cache setObject:attributes forKey:key];
}

- (void)setChallengeDays:(NSArray *)challengeDays forIntent:(PFObject *)intent
{
  NSString *key = [self keyForIntent:intent];
  [self.cache setObject:challengeDays forKey:key];
}

- (void)setActiveIntent:(PFObject *)intent user:(PFUser *)user
{
  NSString *key = [self keyForActiveIntent:user];
  [self.cache setObject:intent forKey:key];
}

- (void)setIntents:(NSArray *)intents forUser:(PFUser *)user
{
  NSString *key = [self keyForUser:user];
  [self.cache setObject:intents forKey:key];
}

- (NSString *)keyForChallengeDay:(PFObject *)challengeDay
{
  return [NSString stringWithFormat:@"challengeDay_%@",[challengeDay objectId]];
}

- (NSString *)keyForActiveIntent:(PFUser *)user
{
  return [NSString stringWithFormat:@"active_intent_%@",[user objectId]];
}

- (NSString *)keyForIntent:(PFObject *)intent
{
  return [NSString stringWithFormat:@"intent_%@",[intent objectId]];
}

- (NSString *)keyForUser:(PFUser *)user
{
  return [NSString stringWithFormat:@"user_%@",[user objectId]];
}

@end
