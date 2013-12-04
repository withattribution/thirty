//
//  UserInfoHeader.h
//  daytoday
//
//  Created by pasmo on 10/8/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NINetworkImageView.h"

@interface UserInfoHeader : UIView <NINetworkImageViewDelegate>

- (id)initWithFrame:(CGRect)frame withUser:(PFUser *)user;

@end
