//
//  ChallengeName.h
//  daytoday
//
//  Created by pasmo on 10/23/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeName : UIView

@property (strong, nonatomic) NSString *name; //observed property
@property (strong, nonatomic) NSString *isEditing; //observed property

- (void)shouldBeFirstResponder;
- (void)namingDidComplete:(void (^)())block;

@end
