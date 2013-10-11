//
//  ProfileSectionHeaderView.h
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"

@interface ProfileSectionHeaderView : UITableViewHeaderFooterView

//@property (nonatomic,retain) Intent *intent;
@property (nonatomic,retain) UILabel *challengeLabel;
@property (nonatomic,retain) NINetworkImageView *sectionImageView;

@end
