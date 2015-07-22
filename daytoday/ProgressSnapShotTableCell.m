//
//  ProgressSnapShotTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ProgressSnapShotTableCell.h"
#import "DTChallengeCalendar.h"
#import "DTProgressRow.h"
//#import "DTProgressElement.h"

@implementation ProgressSnapShotTableCell
@synthesize snapShotElements;

//static CGFloat ROW_SPACING = 2.f;
//static CGFloat TOP_PADDING = 2.f;
//static CGFloat ROW_HEIGHT = 40.f;
//static int WEEK_ROWS = 2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(PFObject *)intent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      if (![[intent objectForKey:kDTIntentAccomplishedIntentKey] boolValue])
      {
        [[DTCommonRequests retrieveDaysForIntent:intent]
         continueWithExecutor:[BFExecutor mainThreadExecutor]
         withBlock:^id(BFTask *days) {
          if ([days.result count] > 0) {
            DTChallengeCalendar *challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
         
            CGRect rowRect = CGRectMake(0.f,
                                        0.f,
                                        self.frame.size.width,
                                        40.f);
            
            for (int i = 0; i < [[challengeCalendar rows] count]; i++) {
              NSDate *rowWeekDate = [[DTCommonUtilities commonCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                                   value:-1*([challengeCalendar rowLength])*i
                                                                                  toDate:[NSDate date]
                                                                                  options:0];

              if( [challengeCalendar endStyleForDate:rowWeekDate] != DTProgressRowEndUndefined) {
                
                rowRect.origin.y = 45.0f*i+5.0f;
                
                DTProgressRow *prow1 = [[DTProgressRow alloc] initWithFrame:rowRect];
                [prow1 setDataSource:challengeCalendar];
                [prow1 setRowInset:5.0f];
                [self addSubview:prow1];
                [prow1 reloadData:YES date:rowWeekDate];
              }
            }
          }
          return nil;
        }];
        [self setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];
      }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
