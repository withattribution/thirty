//
//  ProgressSummaryCell.m
//  daytoday
//
//  Created by pasmo on 10/17/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressSummaryCell.h"

#import "DTDotElement.h"

@implementation ProgressSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSummaryView:(UIView *)sv completion:(CGFloat)percent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubview:sv];
        
        DTDotElement *percentCircle = [[DTDotElement alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0f, 30.0f)
                                                            andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
                                                                andNumber:[NSNumber numberWithInt:60]];
        CGSize txtSize = [@"% COMPLETED" sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13] constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

        UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(percentCircle.frame.size.width + 3.0f,
                                                                          0.0f,
                                                                          txtSize.width,
                                                                          30.0f)];
        percentLabel.textColor = [UIColor grayColor];
        percentLabel.backgroundColor = [UIColor clearColor];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        percentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        percentLabel.text = @"% COMPLETED";

        CGRect centerFrame = CGRectMake(0.0, 0.0, percentCircle.frame.size.width + 3.0f + percentLabel.frame.size.width, 30.0f);
        UIView *centeredView = [[UIView alloc] initWithFrame:centerFrame];

        [centeredView addSubview:percentCircle];
        [centeredView addSubview:percentLabel];
        
        [centeredView setCenter:CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sv.frame.size.height )];
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
