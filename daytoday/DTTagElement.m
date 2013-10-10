//
//  DTTagElement.m
//  daytoday
//
//  Created by pasmo on 10/8/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTTagElement.h"
#import "DTCaret.h"

@implementation DTTagElement

static CGFloat MIN_WIDTH = 45.f;
static CGFloat TAG_PADDING = 2.0f;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:6]
                        constrainedToSize:CGSizeMake(self.frame.size.width,self.frame.size.height)];
        
        DTCaret *c = [[DTCaret alloc] initWithFrame:CGRectMake(0.f,
                                                               0.f,
                                                               textSize.height+TAG_PADDING,
                                                               textSize.height+(2*TAG_PADDING))];
        [c rotateCaretPointLeft];
        [self addSubview:c];
        
        if (textSize.width < MIN_WIDTH) textSize.width = MIN_WIDTH;
        
        UIView *labelBacking = [[UIView alloc] initWithFrame:CGRectMake(c.frame.size.width-(TAG_PADDING*.5),
                                                                        0.f,
                                                                        textSize.width + (2*TAG_PADDING),
                                                                        c.frame.size.height + TAG_PADDING)];
        [labelBacking setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:labelBacking];
        
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(c.frame.size.width-TAG_PADDING,
                                                                      0.f,
                                                                      textSize.width + (2*TAG_PADDING),
                                                                      c.frame.size.height + (TAG_PADDING*.5))];
        tagLabel.textColor = [UIColor colorWithWhite:1.f alpha:1.f];
        tagLabel.backgroundColor = [UIColor clearColor];
        tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:6];
        tagLabel.text = text;
        tagLabel.numberOfLines = 1;
        tagLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:tagLabel];
    }
    return self;
}

@end
