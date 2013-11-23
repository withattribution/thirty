//
//  ParticipantsTableCell.h
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Intent+D2D.h"

@interface ParticipantsTableCell : UITableViewCell

@property (nonatomic,retain) Intent *intent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntent:(Intent *)i;

@end
