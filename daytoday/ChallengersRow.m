//
//  ChallengersRow.m
//  daytoday
//
//  Created by pasmo on 10/8/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "ChallengersRow.h"
#import "DTDotElement.h"
#import "DTDotColorGroup.h"
#import "DTTagElement.h"

//a row of the challenger profiles
//the dot circle with the challenger count
//a tag with the word challengers in it

@interface ChallengersRow ()

- (CGFloat)calculateChallegerEndPoint:(int)cc;

@end

@implementation ChallengersRow

static CGFloat PADDING = 3.0f;
static int CHALLENGER_LIMIT = 5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
        
        DTTagElement *chTag = [[DTTagElement alloc] initWithFrame:CGRectMake(cCount.frame.origin.x + self.frame.size.height-(4*PADDING),
                                                               cCount.center.y - (2*PADDING),
                                                               0.f,
                                                               0.f)
                                         withString:@"CHALLENGERS"];
        [self addSubview:chTag];
    }
    return self;
}

- (CGFloat)calculateChallegerEndPoint:(int)cc
{
    return cc*(self.frame.size.height-(2*PADDING)) + (cc*PADDING);
}
@end
