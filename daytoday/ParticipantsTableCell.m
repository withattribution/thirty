//
//  ParticipantsTableCell.m
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Challenge+D2D.h"
#import "User+D2D.h"

#import "ParticipantsTableCell.h"

@implementation ParticipantsTableCell
@synthesize intent;

static CGFloat PADDING = 1.5f;
static int CHALLENGER_LIMIT = 4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(Intent *)i
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.intent = i;
        int challengerCount = [self.intent.challenge.intents count];

        //TDOD user has the profile images you need
        for (int i = 0; i < CHALLENGER_LIMIT ; i++) {
            UIImageView *ch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileBlank.png"]];
            
            ch.frame = CGRectMake(PADDING + (i*(self.frame.size.height - (1*PADDING))),
                                  PADDING,
                                  self.frame.size.height - (2*PADDING),
                                  self.frame.size.height - (2*PADDING));
            [self addSubview:ch];
        }

        NSString *challegnersText = ( challengerCount > 1 ) ? NSLocalizedString(@"PARTICIPANTS", @"participant-plural")
                                                            : NSLocalizedString(@"PARTICIPANT", @"participant-singular");

        CGRect titleLabelRect = [challegnersText boundingRectWithSize:CGSizeMake(self.frame.size.width/3.f,FLT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                              context:nil];

        UILabel *challengersLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - titleLabelRect.size.width - (5*PADDING),
                                                                              0.f,
                                                                              titleLabelRect.size.width + PADDING,
                                                                              self.frame.size.height)];
        challengersLabel.textColor = [UIColor darkGrayColor];
        challengersLabel.backgroundColor = [UIColor clearColor];
        challengersLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        challengersLabel.text = challegnersText;
        challengersLabel.numberOfLines = 1;
        challengersLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:challengersLabel];
        
        CGRect ChallengersLabelRect = [challegnersText boundingRectWithSize:CGSizeMake(self.frame.size.width/3.f,FLT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:nil context:nil];
        
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(challengersLabel.frame.origin.x,
                                                                     29.,
                                                                     ChallengersLabelRect.size.width,
                                                                     2.f)];
        [underline setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self addSubview:underline];
        
        CGRect countLabelRect = [[NSString stringWithFormat:@"%d",challengerCount] boundingRectWithSize:CGSizeMake(self.frame.size.width/3.f,FLT_MAX)
                                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-BOLD" size:22]}
                                                                                                context:nil];
        
        UILabel *challengerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(challengersLabel.frame.origin.x - countLabelRect.size.width - (2*PADDING),
                                                                                  0.f,
                                                                                  countLabelRect.size.width,
                                                                                  self.frame.size.height)];
        challengerCountLabel.textColor = [UIColor darkGrayColor];
        challengerCountLabel.backgroundColor = [UIColor clearColor];
        challengerCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-BOLD" size:22];
        challengerCountLabel.text = [NSString stringWithFormat:@"%d",challengerCount];
        challengerCountLabel.numberOfLines = 1;
        challengerCountLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:challengerCountLabel];

        [self setBackgroundColor:[UIColor colorWithWhite:.95f alpha:1.0]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end