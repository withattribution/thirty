//
//  DTProfileImageView.h
//  daytoday
//
//  Created by pasmo on 12/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTProfileImageView : UIView

@property (nonatomic,strong) UIButton *profileButton;
@property (nonatomic,strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;

@end
