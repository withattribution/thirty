//
//  DaysLeftTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DaysLeftTableCell.h"

//#import "DTDotElement.h"
//#import "DTDotColorGroup.h"

@implementation DaysLeftTableCell
@synthesize daysLeft,monthSpan;

static CGFloat PADDING = 3.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.monthSpan = [[UILabel alloc] initWithFrame:CGRectMake(2*PADDING,
                                                                   0.f,
                                                                   165.f,
                                                                   40.)];
        self.monthSpan.textColor = [UIColor darkGrayColor];
        self.monthSpan.backgroundColor = [UIColor clearColor];
        self.monthSpan.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        self.monthSpan.text = @"JULY - AUGUST 2013";
        self.monthSpan.numberOfLines = 1;
        self.monthSpan.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.monthSpan];
        
        self.daysLeft = [[UILabel alloc] initWithFrame:CGRectMake(320. - 70. - 27. - PADDING,
                                                                  0.f,
                                                                  70.f,
                                                                  40.)];
        self.daysLeft.textColor = [UIColor darkGrayColor];
        self.daysLeft.backgroundColor = [UIColor clearColor];
        self.daysLeft.font = [UIFont fontWithName:@"HelveticaNeue-BOLD" size:22];
        self.daysLeft.text = @"20";
        self.daysLeft.numberOfLines = 1;
        self.daysLeft.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.daysLeft];
        
        UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(320. - 70. - PADDING,
                                                                       0.f,
                                                                       70.f,
                                                                       38.)];
        daysLabel.textColor = [UIColor darkGrayColor];
        daysLabel.backgroundColor = [UIColor clearColor];
        daysLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        daysLabel.text = @"DAYS LEFT";
        daysLabel.numberOfLines = 1;
        daysLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:daysLabel];
        
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(daysLabel.frame.origin.x, 26., daysLeft.frame.size.width - PADDING, 2.f)];
        [underline setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self addSubview:underline];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:95]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
