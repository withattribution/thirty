//
//  ProgressSummaryCell.m
//  daytoday
//
//  Created by pasmo on 10/17/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ProgressSummaryCell.h"
#import "DTProgressElement.h"

@implementation ProgressSummaryCell

static CGFloat PADDING = 1.5f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(PFObject *)intent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      //generate progress view here
      
      CGFloat percent = [[intent objectForKey:kDTIntentPercentComplete] floatValue];
      
      UIView *sv = [[DTProgressElement alloc] initForSummaryElement:percent];
      sv.center = CGPointMake(self.frame.size.width/2, sv.center.y+10);

      [self addSubview:sv];
    
      NSString *percentText = [NSString stringWithFormat:@"%.0f%% COMPLETED",(percent * 100.)];
      
      CGRect percentLabelRect = [percentText boundingRectWithSize:CGSizeMake(self.frame.size.width/2.f,FLT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                            context:nil];
      
      UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f,
                                                                        sv.frame.origin.y + sv.frame.size.height + (2*PADDING),
                                                                        self.frame.size.width,
                                                                        percentLabelRect.size.height)];
      percentLabel.textColor = [UIColor grayColor];
      percentLabel.backgroundColor = [UIColor clearColor];
      percentLabel.textAlignment = NSTextAlignmentCenter;
      percentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
      percentLabel.text = percentText;
      [self addSubview:percentLabel];
      
      UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(percentLabel.frame.origin.x,
                                                                   percentLabel.frame.origin.y + percentLabel.frame.size.height,
                                                                   percentLabelRect.size.width,
                                                                   2.f)];
      [underline setCenter:CGPointMake(self.frame.size.width /2. , (self.frame.size.height / 2.) + sv.frame.size.height+10)];
      [underline setTag:NSIntegerMax];
      [underline setBackgroundColor:[UIColor redColor]];
      
      [self addSubview:underline];
      
      

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  for (UIView *v in self.subviews) {
    if (v.tag == NSIntegerMax) {
      v.backgroundColor = [UIColor purpleColor];
    }
  }
  
}

@end