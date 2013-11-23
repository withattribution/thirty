//
//  DaysLeftTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DaysLeftTableCell.h"

@implementation DaysLeftTableCell
@synthesize intent;

static CGFloat PADDING = 1.5f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(Intent *)i
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.intent = i;
        UILabel *monthSpan = [[UILabel alloc] initWithFrame:CGRectMake(5*PADDING,
                                                                       0.f,
                                                                       280.f,
                                                                       40.)];
        monthSpan.textColor = [UIColor darkGrayColor];
        monthSpan.backgroundColor = [UIColor clearColor];
        monthSpan.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        monthSpan.text = self.intent.monthSpan;
        monthSpan.numberOfLines = 1;
        monthSpan.textAlignment = NSTextAlignmentLeft;
        [self addSubview:monthSpan];
        
        NSString *daysLabelText = ( self.intent.daysLeft == 1 ) ? NSLocalizedString(@"DAY LEFT", @"dayCount-singular")
                                                                : NSLocalizedString(@"DAYS LEFT", @"dayCount-plural");

        CGRect daysLeftRect = [daysLabelText boundingRectWithSize:CGSizeMake(self.frame.size.width/3.f,FLT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                          context:nil];
        
        UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - daysLeftRect.size.width - (5*PADDING),
                                                                       0.f,
                                                                       daysLeftRect.size.width + PADDING,
                                                                       self.frame.size.height)];
        daysLabel.textColor = [UIColor darkGrayColor];
        daysLabel.backgroundColor = [UIColor clearColor];
        daysLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        daysLabel.text = daysLabelText;
        daysLabel.numberOfLines = 1;
        daysLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:daysLabel];
        
        NSString *daysCountText = [NSString stringWithFormat:@"%d",self.intent.daysLeft];
        CGRect daysCountRect = [daysCountText boundingRectWithSize:CGSizeMake(self.frame.size.width/3.f,FLT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-BOLD" size:22]}
                                                          context:nil];
        
        UILabel *daysLeft = [[UILabel alloc] initWithFrame:CGRectMake(daysLabel.frame.origin.x - daysCountRect.size.width - (2*PADDING),
                                                                      0.f,
                                                                      daysCountRect.size.width,
                                                                      self.frame.size.height)];
        daysLeft.textColor = [UIColor darkGrayColor];
        daysLeft.backgroundColor = [UIColor clearColor];
        daysLeft.font = [UIFont fontWithName:@"HelveticaNeue-BOLD" size:22];
        daysLeft.text = daysCountText;
        daysLeft.numberOfLines = 1;
        daysLeft.textAlignment = NSTextAlignmentLeft;
                
        [self addSubview:daysLeft];
        
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(daysLabel.frame.origin.x,
                                                                     29.f,
                                                                     daysLeftRect.size.width,
                                                                     2.f)];
        [underline setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self addSubview:underline];

        [self setBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.f]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end