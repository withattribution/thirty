//
//  D2ViewController.h
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIColor+SR.h>
@interface D2ViewController : UIViewController

- (UIColor*)randomColor;
- (NSManagedObjectContext*)context;
- (CGFloat)padWithStatusBarHeight;

@end
