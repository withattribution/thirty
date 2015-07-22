//
//  DTChallengeCalendarSpec.m
//  daytoday
//
//  Created by peanut on 7/13/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "Specs.h"
#import "DTChallengeCalendarSpecHelpers.h"
#import "DTChallengeCalendar.h"
#import "DTProgressRow.h"

SpecBegin(DTChallengeCalendarBehaviors)

describe(@"Challenge Calendars", ^{

  __block id intent = nil;
  __block id challengeCalendar = nil;

  afterEach(^{
    waitUntil(^(DoneCallback done) {
      [[PFObject unpinAllObjectsInBackground] continueWithSuccessBlock:^id(BFTask *clear){
        intent = nil;
        challengeCalendar = nil;
        [[DTCache sharedCache] clear];
        done();
        return nil;
      }];
    });
  });

  context(@"intent starting today", ^{
    it(@"first day", ^{
      intent = [DTChallengeCalendarSpecHelpers intentStartingToday];
      //match challenge duration with cached challenge day count
      expect([[[intent objectForKey:kDTIntentChallengeKey] objectForKey:kDTChallengeDurationKey] intValue])
      .to.equal([[[DTCache sharedCache] challengeDaysForIntent:intent] count]);
      
      challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
      DTProgressRow *prow = [[DTProgressRow alloc] initWithFrame:CGRectZero];
      [prow setDataSource:challengeCalendar];

      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers startingDate:intent]]).to.equal(DTProgressRowEndBothRounded);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers halfWayDone:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers endingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekBeforeStartingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterEndingDate:intent]]).to.equal(DTProgressRowEndUndefined);
    });
  });

  context(@"intent starting a week ago", ^{
    it(@"one week in", ^{
      intent = [DTChallengeCalendarSpecHelpers intentStartingOneWeekAgo];
      //match challenge duration with cached challenge day count
      expect([[[intent objectForKey:kDTIntentChallengeKey] objectForKey:kDTChallengeDurationKey] intValue])
      .to.equal([[[DTCache sharedCache] challengeDaysForIntent:intent] count]);

      challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
      DTProgressRow *prow = [[DTProgressRow alloc] initWithFrame:CGRectZero];
      [prow setDataSource:challengeCalendar];

      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers startingDate:intent]]).to.equal(DTProgressRowEndFlatRight);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]]).to.equal(DTProgressRowEndFlatLeft);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers halfWayDone:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers endingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekBeforeStartingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterEndingDate:intent]]).to.equal(DTProgressRowEndUndefined);
    });
  });

  context(@"intent half way done", ^{
    it(@"half way", ^{
      intent = [DTChallengeCalendarSpecHelpers intentHalfWayDone];
      //match challenge duration with cached challenge day count
      expect([[[intent objectForKey:kDTIntentChallengeKey] objectForKey:kDTChallengeDurationKey] intValue])
      .to.equal([[[DTCache sharedCache] challengeDaysForIntent:intent] count]);

      challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
      DTProgressRow *prow = [[DTProgressRow alloc] initWithFrame:CGRectZero];
      [prow setDataSource:challengeCalendar];
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers startingDate:intent]]).to.equal(DTProgressRowEndFlatRight);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers halfWayDone:intent]]).to.equal(DTProgressRowEndFlatLeft);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers endingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekBeforeStartingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterEndingDate:intent]]).to.equal(DTProgressRowEndUndefined);
    });
  });

  context(@"intent ending in one week", ^{
    it(@"last week", ^{
      intent = [DTChallengeCalendarSpecHelpers intentEndingInOneWeek];
      //match challenge duration with cached challenge day count
      expect([[[intent objectForKey:kDTIntentChallengeKey] objectForKey:kDTChallengeDurationKey] intValue])
      .to.equal([[[DTCache sharedCache] challengeDaysForIntent:intent] count]);
      
      challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
      DTProgressRow *prow = [[DTProgressRow alloc] initWithFrame:CGRectZero];
      [prow setDataSource:challengeCalendar];
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers startingDate:intent]]).to.equal(DTProgressRowEndFlatRight);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers halfWayDone:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]]).to.equal(DTProgressRowEndFlatLeft);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers endingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekBeforeStartingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterEndingDate:intent]]).to.equal(DTProgressRowEndUndefined);
    });
  });

  context(@"intent ending today", ^{
    it(@"last day", ^{
      intent = [DTChallengeCalendarSpecHelpers intentEndingToday];
      //match challenge duration with cached challenge day count
      expect([[[intent objectForKey:kDTIntentChallengeKey] objectForKey:kDTChallengeDurationKey] intValue])
      .to.equal([[[DTCache sharedCache] challengeDaysForIntent:intent] count]);
      
      challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
      DTProgressRow *prow = [[DTProgressRow alloc] initWithFrame:CGRectZero];
      [prow setDataSource:challengeCalendar];
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers startingDate:intent]]).to.equal(DTProgressRowEndFlatRight);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers halfWayDone:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]]).to.equal(DTProgressRowEndFlat);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers endingDate:intent]]).to.equal(DTProgressRowEndFlatLeft);
      
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekBeforeStartingDate:intent]]).to.equal(DTProgressRowEndUndefined);
      expect([challengeCalendar endStyleForDate:[DTChallengeCalendarSpecHelpers oneWeekAfterEndingDate:intent]]).to.equal(DTProgressRowEndUndefined);
    });
  });
  
});

SpecEnd