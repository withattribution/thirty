//
//  ProgressSummaryCell.h
//  daytoday
//
//  Created by pasmo on 10/17/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressSummaryCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSummaryView:(UIView *)sv completion:(CGFloat)percent;

@end
