//
//  DTSelectionSheet.h
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSelectionSheet : UIView

@property (nonatomic,retain) NSString *titleText;

+ (id)selectionSheetWithTitle:(NSString *)t;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
