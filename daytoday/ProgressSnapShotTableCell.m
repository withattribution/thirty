//
//  ProgressSnapShotTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ProgressSnapShotTableCell.h"
#import "DTProgressElement.h"

#import "UIColor+SR.h"

@implementation ProgressSnapShotTableCell
@synthesize snapShotElements;

static CGFloat ROW_SPACING = 2.f;
static CGFloat TOP_PADDING = 2.f;
static CGFloat ROW_HEIGHT = 40.f;
static int WEEK_ROWS = 2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDTProgressRows:(NSArray *)rows
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.snapShotElements = rows;
        
        [self setFrame:CGRectMake(0.f,
                                  self.frame.origin.y,
                                  self.frame.size.width,
                                  (WEEK_ROWS * ROW_HEIGHT) + (2*TOP_PADDING) + ROW_SPACING)];
        
        if (self.snapShotElements && [self.snapShotElements count] > 0) {
            [self addSubview:[self.snapShotElements objectAtIndex:0]];
        }
        
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                                      ROW_HEIGHT + 2.f,
                                                                      self.frame.size.width,
                                                                      ROW_SPACING)];
        [spacerView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:1.f]];
        [self addSubview:spacerView];
        
        if (self.snapShotElements && [self.snapShotElements count] > 0) {
            [[self.snapShotElements objectAtIndex:1] setFrame:CGRectMake(0.,
                                                                         spacerView.frame.origin.y + spacerView.frame.size.height,
                                                                         self.frame.size.width,
                                                                         ROW_HEIGHT)];
            
            [self addSubview:[self.snapShotElements objectAtIndex:1]];
        }
        
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
