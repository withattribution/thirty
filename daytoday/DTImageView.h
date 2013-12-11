//
//  DTImageView.h
//  daytoday
//
//  Created by pasmo on 12/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTImageView : UIImageView

@property(nonatomic,strong) UIImage *placeholderImage;

- (void) setFile:(PFFile *)file;

@end
