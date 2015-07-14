//
//  DTChallengeCalendarHelpers.h
//  daytoday
//
//  Created by peanut on 7/13/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

@interface DTChallengeCalendarSpecHelpers : NSObject

//intent creation for several set challenge situations
+ (PFObject *)intentStartingToday;
+ (PFObject *)intentStartingOneWeekAgo;
+ (PFObject *)intentHalfWayDone;
+ (PFObject *)intentEndingInOneWeek;

+ (NSDate *)startingDate:(PFObject *)intent;
+ (NSDate *)oneWeekAfterStarting:(PFObject *)intent;
+ (NSDate *)halfWayDone:(PFObject *)intent;
+ (NSDate *)lastWeekUntilEnding:(PFObject *)intent;

@end
