//
//  ChallengeDayDetail.m
//  daytoday
//
//  Created by pasmo on 11/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDayDetail.h"

@implementation ChallengeDayDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      NSUInteger dayCount = 20; //example days left

      NSString *day = NSLocalizedString(@"DAY", @"day for day today label");
      NSString *today = NSLocalizedString(@"TODAY", @"today for day today label");

      NSUInteger dayLength = [day length];
      NSUInteger todayLength = [today length];

      NSString *daysLeft = [NSString stringWithFormat:@"%d",dayCount];
      NSUInteger daysLeftLength = [daysLeft length];

      NSString *dayTodayPhrase = [NSString stringWithFormat:@"%@ %@ %@",day,daysLeft,today];

      NSMutableAttributedString *dayTodayString = [[NSMutableAttributedString alloc] initWithString:dayTodayPhrase];

      [dayTodayString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica-Bold" size:20.f]
                             range:NSMakeRange(0, dayLength)];

      [dayTodayString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica-Bold" size:20.f]
                             range:NSMakeRange(dayLength+1, daysLeftLength)];

      [dayTodayString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica-Bold" size:20.f]
                             range:NSMakeRange(dayLength+daysLeftLength+2, todayLength)];

      [dayTodayString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithWhite:.5f alpha:1.f]
                             range:NSMakeRange(0, dayLength)];

      [dayTodayString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blueColor]
                             range:NSMakeRange(dayLength+1, daysLeftLength)];

      [dayTodayString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithWhite:.5f alpha:1.f]
                             range:NSMakeRange(dayLength+daysLeftLength+2, todayLength)];

      CGSize maxSize = CGSizeMake(320.f, 200.f);

      UILabel *dayTodayLabel = [[UILabel alloc] init];
      CGSize requiredSize = [dayTodayLabel sizeThatFits:maxSize];
      [dayTodayLabel setFrame:CGRectMake(0.f, 0.f, requiredSize.width, requiredSize.height)];
      [dayTodayLabel setBackgroundColor:[UIColor clearColor]];
      [dayTodayLabel setAttributedText:dayTodayString];
      [dayTodayLabel setNumberOfLines:1];
      [dayTodayLabel sizeToFit];
      [dayTodayLabel setCenter:CGPointMake(self.frame.size.width/2, dayTodayLabel.center.y + 20)];
      [self addSubview:dayTodayLabel];
    }
    return self;
}

@end
