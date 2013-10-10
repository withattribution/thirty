//
//  UserInfoHeader.m
//  daytoday
//
//  Created by pasmo on 10/8/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "UserInfoHeader.h"

//This is the basic user info layout for
// the user image
// the users full name or user name
// the number of challenges the user has participated in
// the number of followers
// and the number of users following
// also the way to toggle between the history and the saved list of challenges

@implementation UserInfoHeader

static CGFloat INFO_PADDING = 3.0f;
static CGFloat PROFILE_SIZE = 100.0f;
static int LABEL_ROWS = 3;

#define HISTORY_TAG 30
#define SAVED_TAG 31

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileBlank.png"]];
        userImage.frame = CGRectMake(INFO_PADDING, INFO_PADDING, PROFILE_SIZE, PROFILE_SIZE);
        [self addSubview:userImage];
        
        //space to the right of the user Image
        CGFloat labelWidth = self.frame.size.width - (userImage.frame.size.width + (3*INFO_PADDING));
        CGFloat labelHeight = ( userImage.frame.size.height - (2*INFO_PADDING) ) / LABEL_ROWS;
        CGFloat labelXoffset = userImage.frame.size.width+(2*INFO_PADDING);
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(labelXoffset,
                                                                  INFO_PADDING,
                                                                  labelWidth,
                                                                  labelHeight)];
        name.textColor = [UIColor darkGrayColor];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        name.text = @"patient zero";
        name.numberOfLines = 1;
        name.textAlignment = NSTextAlignmentCenter;
        [name.layer setBorderWidth:1.0];
        [name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self addSubview:name];
        
        //create the 3 labels for challenges count, followers and following
        for (int i = 0; i < 3; i++) {
            CGFloat subLabelXOffset = (i*(labelWidth/3.0f));
            
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(labelXoffset + subLabelXOffset,
                                                                 labelHeight + (2.0f*INFO_PADDING),
                                                                 labelWidth/3.0f,
                                                                 labelHeight)];
            [v.layer setBorderWidth:1.0];
            [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            
            UILabel *count = [[UILabel alloc] initWithFrame:CGRectZero];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];

            count.frame = CGRectMake(0.0f,
                                     0.0f,
                                     v.frame.size.width,
                                     v.frame.size.height*(2.0f/3.0f));
            
            label.frame = CGRectMake(0.0f,
                                     v.frame.size.height*(2.0f/3.0f),
                                     v.frame.size.width,
                                     v.frame.size.height*(1.0f/4.0f));
        
            switch (i) {
                case 0:
                    count.text = @"3";
                    label.text = @"CHALLENGERS";
                    break;
                case 1:
                    count.text = @"44";
                    label.text = @"FOLLOWERS";
                    break;
                case 2:
                    count.text = @"100";
                    label.text = @"FOLLOWING";
                    break;
                default:
                    break;
            }
            
            count.textColor = [UIColor darkGrayColor];
            count.backgroundColor = [UIColor clearColor];
            count.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            count.numberOfLines = 1;
            count.textAlignment = NSTextAlignmentCenter;
            [v addSubview:count];
            
            label.textColor = [UIColor lightGrayColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:8];
            label.numberOfLines = 1;
            label.textAlignment = NSTextAlignmentCenter;
            [v addSubview:label];
            
            [self addSubview:v];
        }
        
        for (int i = 0; i < 2; i++) {
            CGFloat toggelWidth = (labelWidth - INFO_PADDING) / 2.0f;
            
            UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *toggleText = @"WRONG";

            switch (i) {
                case 0:
                    toggleText = NSLocalizedString(@"HISTORY", @"the users challenge history");
                    toggleButton.frame = CGRectMake(labelXoffset + toggelWidth*i,
                                                    (2*labelHeight) + (3*INFO_PADDING),
                                                    toggelWidth,
                                                    labelHeight);
                    toggleButton.tag = HISTORY_TAG;
                    break;
                case 1:
                    toggleText = NSLocalizedString(@"SAVED", @"all the saved challenges");
                    toggleButton.frame = CGRectMake(labelXoffset + toggelWidth*i + INFO_PADDING,
                                                    (2*labelHeight) + (3*INFO_PADDING)
                                                    ,toggelWidth,
                                                    labelHeight);
                    toggleButton.tag = SAVED_TAG;
                    break;
                default:
                    break;
            }
            
            [toggleButton.titleLabel setTextColor:[UIColor darkGrayColor]];
            [toggleButton setBackgroundColor:[UIColor lightGrayColor]];
            
            [toggleButton setTitle:toggleText forState:UIControlStateNormal];
            [toggleButton addTarget:self
                             action:@selector(toggleHistorySavedFeed:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:toggleButton];
        }
    }
    return self;
}

-(void) toggleHistorySavedFeed:(UIButton *)sender
{
    if (sender.tag == HISTORY_TAG) {
            NSLog(@"history feed");
    }
    
    if (sender.tag == SAVED_TAG) {
        NSLog(@"saved feed");
    }
}
@end
