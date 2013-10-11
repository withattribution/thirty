//
//  ProfileTableCell.m
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProfileTableCell.h"

#import "DaysLeftView.h"
#import "ProgressSnapshotView.h"
#import "ChallengersRow.h"

#import "UIColor+SR.h"

@implementation ProfileTableCell

@synthesize contentHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DaysLeftView *daysCount = [[DaysLeftView alloc] initWithFrame:CGRectMake(0.f,
                                                                                 0.f,
                                                                                 self.frame.size.width,
                                                                                 40.f)];
        [self addSubview:daysCount];
        
        self.contentHeight = daysCount.frame.origin.y + daysCount.frame.size.height;
        
        ProgressSnapshotView *twoWeekProgress = [[ProgressSnapshotView alloc] initWithFrame:CGRectMake(0.f,
                                                                                                       self.contentHeight,
                                                                                                       self.frame.size.width,
                                                                                                       40.f)];
        [self addSubview:twoWeekProgress];

        self.contentHeight += twoWeekProgress.frame.size.height;
        
        ChallengersRow *chRow = [[ChallengersRow alloc] initWithFrame:CGRectMake(0.f,
                                                                                 self.contentHeight,
                                                                                 self.frame.size.width,
                                                                                 40.f)];
        [self addSubview:chRow];
        
        self.contentHeight += chRow.frame.size.height;
        
//        NSLog(@"height: %f", self.contentHeight);
    }
    return self;
}

- (CGFloat) getContentHeight
{
    return self.contentHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
