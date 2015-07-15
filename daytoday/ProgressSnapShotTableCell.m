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

static CGFloat ROW_SPACING = 2.f;
static CGFloat TOP_PADDING = 2.f;
static CGFloat ROW_HEIGHT = 40.f;
static int WEEK_ROWS = 2;

//self.calendarObject = [DTChallengeCalendar calendarWithIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
//self.rowView = [[DTProgressRow alloc] initWithFrame:CGRectMake(0.f, self.cdd.frame.origin.y + self.cdd.frame.size.height + 15., self.view.frame.size.width, 40.f)];
//
//[self.rowView setDelegate:self];
//[self.rowView setDataSource:self.calendarObject];
//[self.rowView setRowInset:kVerificationDayInset];
//[self.view addSubview:self.rowView];


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(PFObject *)intent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.snapShotElements = rows;
      NSArray *rows = [[DTChallengeCalendar calendarWithIntent:intent] rows];

      if (rows.count > 0) {
        DTProgressRow *rowTest = [[DTProgressRow alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 50.0f)];

        [rowTest setDataSource:[DTChallengeCalendar calendarWithIntent:intent]];
        [rowTest setRowInset:3.0];
        [rowTest setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:rowTest];
      }

//        [self setFrame:CGRectMake(0.f,
//                                  self.frame.origin.y,
//                                  self.frame.size.width,
//                                  (WEEK_ROWS * ROW_HEIGHT) + (2*TOP_PADDING) + ROW_SPACING)];

//        if (self.snapShotElements && [self.snapShotElements count] > 0) {
//            [self addSubview:[self.snapShotElements objectAtIndex:0]];
//        }

        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                                      ROW_HEIGHT + 2.f,
                                                                      self.frame.size.width,
                                                                      ROW_SPACING)];
        [spacerView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:1.f]];
//        [self addSubview:spacerView];

//        if (self.snapShotElements && [self.snapShotElements count] > 0) {
//            [[self.snapShotElements objectAtIndex:1] setFrame:CGRectMake(0.,
//                                                                         spacerView.frame.origin.y + spacerView.frame.size.height,
//                                                                         self.frame.size.width,
//                                                                         ROW_HEIGHT)];
//            
//            [self addSubview:[self.snapShotElements objectAtIndex:1]];
//        }
        [self setBackgroundColor:[UIColor colorWithWhite:.5f alpha:1.f]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
