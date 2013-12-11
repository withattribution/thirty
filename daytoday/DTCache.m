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

#pragma mark - Active Challenge Day

+ (PFObject *)cachedActiveDayForDate:(NSDate *)date
{
  
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

#pragma mark - Challenge Days For Intent

- (void)cacheChallengeDays:(NSArray *)days forIntent:(PFObject *)intent
{
  
  NSMutableArray *challengeDays = [NSMutableArray arrayWithCapacity:[days count]];
  for (int i = 0; i < [days count]; i++)
  {
    PFObject *challengeDay = [days objectAtIndex:i];
    NSDictionary *attributes = @{kDTChallengeDayAttributeRequiredKey:[challengeDay objectForKey:kDTChallengeDayTaskRequiredCountKey],
                                 kDTChallengeDayAttributeCompletedKey:[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey],
                                 kDTChallengeDayAttributeAccomplishedKey:[challengeDay objectForKey:kDTChallengeDayAccomplishedKey],
                                 kDTChallengeDayAttributeOrdinalKey:[challengeDay objectForKey:kDTChallengeDayOrdinalDayKey],
                                 kDTChallengeDayAttributeActiveHashKey:[challengeDay objectForKey:kDTChallengeDayActiveHashKey]
//                                 kDTChallengeDayAttributeIntentKey:[challengeDay objectForKey:kDTChallengeDayIntentKey]
                                 };
    [self setAttributes:attributes forChallengeDay:challengeDay];
    [challengeDays addObject:attributes];
  }
  [self setChallengeDays:challengeDays forIntent:intent];
  
  [[NSNotificationCenter defaultCenter]
   postNotificationName:DTChallengeDayDidCacheDaysForIntentNotification
   object:challengeDays
   userInfo:nil];
}

- (NSArray *)challengeDaysForIntent:(PFObject *)intent
{
  NSString *key = [self keyForIntent:intent];
  return [self.cache objectForKey:key];
}

#pragma mark - Intents for User

- (PFObject *)currentActiveIntentForUser:(PFUser *)user
{
#warning need better way to determine if +INTENT+ is active
  NSArray * intents = [self intentsForUser:user];
  return [intents lastObject];
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

- (void)setIntents:(NSArray *)intents forUser:(PFUser *)user
{
  NSString *key = [self keyForUser:user];
  [self.cache setObject:intents forKey:key];
}

- (NSString *)keyForChallengeDay:(PFObject *)challengeDay
{
  return [NSString stringWithFormat:@"challengeDay_%@",[challengeDay objectId]];
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
