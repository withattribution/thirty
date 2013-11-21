//
//  DTCache.m
//  daytoday
//
//  Created by pasmo on 11/19/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
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

@end
