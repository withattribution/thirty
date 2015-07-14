//
//  MockPFObject.m
//  daytoday
//
//  Created by peanut on 7/14/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "MockPFObject.h"
#import <Parse/PFObject+Subclass.h>

@implementation MockPFObject

+ (NSString *)parseClassName {
  return @"MockPFObject";
}

+ (void)load {
  [self registerSubclass];
}

@end
