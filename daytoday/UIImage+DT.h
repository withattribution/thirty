//
//  UIImage+DT.h
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DT)

- (UIImage *) resizeToSize:(CGSize)newSize thenCropWithRect:(CGRect)cropRect;

@end
