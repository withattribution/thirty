//
//  ProgressRowTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressRowTableCell.h"
#import "DTProgressElementLayout.h"
#import "UIColor+SR.h"

@implementation ProgressRowTableCell

static CGFloat ROW_SPACING = 2.f;
static CGFloat TOP_PADDING = 2.f;
static CGFloat ROW_HEIGHT = 40.f;
static int WEEK_ROWS = 2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0.f, self.frame.origin.y, self.frame.size.width, (WEEK_ROWS * ROW_HEIGHT) + (2*TOP_PADDING) + ROW_SPACING)];
        
        DTProgressElementLayout *topRow = [[DTProgressElementLayout alloc] initWithFrame:CGRectMake(0.f,
                                                                                                    1.f,
                                                                                                    self.frame.size.width,
                                                                                                    ROW_HEIGHT)
                                                                             forDayInRow:6];
        [self addSubview:topRow];
        
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, topRow.frame.size.height + 2.f, self.frame.size.width, ROW_SPACING)];
        [spacerView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:1.f]];
        [self addSubview:spacerView];
        
        DTProgressElementLayout *bottomRow = [[DTProgressElementLayout alloc] initWithFrame:CGRectMake(0.0,
                                                                                                       spacerView.frame.origin.y + spacerView.frame.size.height +1.f,
                                                                                                       self.frame.size.width,
                                                                                                       ROW_HEIGHT)
                                                                                forDayInRow:6];
        [self addSubview:bottomRow];
        [self setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
