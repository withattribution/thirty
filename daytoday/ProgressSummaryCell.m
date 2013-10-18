//
//  ProgressSummaryCell.m
//  daytoday
//
//  Created by pasmo on 10/17/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressSummaryCell.h"

@implementation ProgressSummaryCell

static CGFloat PADDING = 1.5f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
    withSummaryView:(UIView *)sv
         completion:(CGFloat)percent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [sv setFrame:CGRectMake(sv.frame.origin.x, sv.frame.origin.y + (2*PADDING), sv.frame.size.width, sv.frame.size.height)];
        [self addSubview:sv];

        NSString *percentText = [NSString stringWithFormat:@"%.0f%% COMPLETED",(percent * 100.)];
        
        CGRect percentLabelRect = [percentText boundingRectWithSize:CGSizeMake(self.frame.size.width/2.f,FLT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                              context:nil];
        
        UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f,
                                                                          sv.frame.origin.y + sv.frame.size.height + (2*PADDING),
                                                                          self.frame.size.width,
                                                                          percentLabelRect.size.height)];
        percentLabel.textColor = [UIColor grayColor];
        percentLabel.backgroundColor = [UIColor clearColor];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        percentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        percentLabel.text = percentText;
        [self addSubview:percentLabel];
        
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(percentLabel.frame.origin.x,
                                                                     percentLabel.frame.origin.y + percentLabel.frame.size.height,
                                                                     percentLabelRect.size.width,
                                                                     2.f)];
        [underline setCenter:CGPointMake(self.frame.size.width /2. , (self.frame.size.height / 2.) + sv.frame.size.height )];
        [underline setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [self addSubview:underline];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end