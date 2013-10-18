//
//  ProgressSummaryCell.m
//  daytoday
//
//  Created by pasmo on 10/17/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressSummaryCell.h"

@implementation ProgressSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
    withSummaryView:(UIView *)sv
         completion:(CGFloat)percent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubview:sv];

        UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f + 3.0f,
                                                                          0.0f,
                                                                          self.frame.size.width,
                                                                          30.0f)];
        percentLabel.textColor = [UIColor grayColor];
        percentLabel.backgroundColor = [UIColor clearColor];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        percentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        percentLabel.text = [NSString stringWithFormat:@"%.0f%% COMPLETED",(percent * 100.)];
 
        CGRect centerFrame = CGRectMake(0.0, 0.0, self.frame.size.width + 3.0f + self.frame.size.width, 30.0f);
        UIView *centeredView = [[UIView alloc] initWithFrame:centerFrame];
        [centeredView addSubview:percentLabel];
        [centeredView setCenter:CGPointMake(self.frame.size.width, (self.frame.size.height / 2.) + sv.frame.size.height )];
        
        CGSize widthForPercent = [percentLabel.text sizeWithFont:percentLabel.font
                                          constrainedToSize:CGSizeMake(percentLabel.frame.size.width,40.)
                                              lineBreakMode:percentLabel.lineBreakMode];
        
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(108.,
                                                                     sv.frame.origin.y+sv.frame.size.height + 30.,
                                                                     widthForPercent.width - 3.,
                                                                     2.f)];

        [underline setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self addSubview:underline];
        
        [self addSubview:centeredView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end