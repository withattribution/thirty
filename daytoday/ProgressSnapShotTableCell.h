//
//  ProgressSnapShotTableCell.h
//  daytoday
//
//  Created by pasmo on 10/12/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressSnapShotTableCell : UITableViewCell

@property (nonatomic,retain) NSArray *snapShotElements;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDTProgressRows:(NSArray *)rows;

@end
