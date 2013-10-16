//
//  ParticipantsRowTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ParticipantsRowTableCell.h"
#import "DTDotElement.h"

@interface ParticipantsRowTableCell ()
- (CGFloat)calculateChallegerEndPoint:(int)cc;
@end

@implementation ParticipantsRowTableCell

static CGFloat PADDING = 1.5f;
static int CHALLENGER_LIMIT = 5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int challengerCount = 8;
        
        for (int i = 0; i < CHALLENGER_LIMIT ; i++) {
            UIImageView *ch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileBlank.png"]];
            
            ch.frame = CGRectMake(PADDING + (i*(self.frame.size.height - (1*PADDING))),
                                  PADDING,
                                  self.frame.size.height - (2*PADDING),
                                  self.frame.size.height - (2*PADDING));
            [self addSubview:ch];
        }
        
        CGFloat challengerEndPoint = [self calculateChallegerEndPoint:(challengerCount > CHALLENGER_LIMIT) ? CHALLENGER_LIMIT : challengerCount];
        
        DTDotElement *cCount = [[DTDotElement alloc] initWithFrame:CGRectMake(challengerEndPoint,
                                                                              PADDING,
                                                                              self.frame.size.height - (2*PADDING),
                                                                              self.frame.size.height - (2*PADDING))
                                                     andColorGroup:[DTDotColorGroup accomplishedDayColorGroup]
                                                         andNumber:[NSNumber numberWithInt:challengerCount]];
        [self addSubview:cCount];
        
        [self setBackgroundColor:[UIColor colorWithWhite:.95f alpha:1.0]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)calculateChallegerEndPoint:(int)cc
{
    return cc*(self.frame.size.height-(2*PADDING)) + (cc*PADDING);
}

@end
