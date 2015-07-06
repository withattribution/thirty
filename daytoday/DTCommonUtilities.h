//
//  DTCommonUtilities.h
//  daytoday
//
//  Created by pasmo on 11/26/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCommonUtilities : NSObject

+ (NSInteger)minutesFromGMTForDate:(NSDate *)date;

+ (NSDateFormatter *)displayDayFormatter;
+ (NSDateFormatter *)dayformatterForSeed;

+ (NSCalendar *)commonCalendar;

+ (uint32_t)challengeUserSeedFromIntent:(PFObject *)intent;
+ (uint32_t)dayHashFromDate:(NSDate *)date intent:(PFObject *)intent;

+ (BFTask *)isValidDateForActiveIntent:(PFObject *)activeIntent;

@end
