//
//  DTViewController.h
//  daytoday
//
//  Created by Alberto Tafoya on 10/1/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "SWRevealViewController.h"
#import "DTGlobalNavigation.h"

@interface DTViewController : UIViewController

@property (nonatomic,strong) SWRevealViewController *revealController;
@property (nonatomic,strong) DTGlobalNavigation *globalNavigation;

- (CGFloat)padWithStatusBarHeight;

@end
