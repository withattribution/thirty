//
//  DaysLeftTableCell.h
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysLeftTableCell : UITableViewCell

@property (nonatomic,retain) PFObject *intent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(PFObject *)i;

@end
