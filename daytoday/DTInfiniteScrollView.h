//
//  DTInfiniteScrollView.h
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTInfiniteScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame views:(NSMutableArray *)views;

//[alertView setClickedButtonAtIndexBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
//  [_networkManager submitLastNameToServer:[alertView textFieldAtIndex:0].text]];
//}];


//[self.infiniteLoopScrollView countToTenThousandAndReturnCompletionBlock:^(BOOL completed) {
//  if (completed) {
//    NSLog(@"talking dolla dolla billz ya'll");
//  }
//
//}];

//- (void)countToTenThousandAndReturnCompletionBlock:(void (^)(BOOL))completed
//{
//  int x = 1;
//  while (x < 10001) {
//    x ++;
//  }
//
//  completed(YES);
//
//}

//- (void)countToTenThousandAndReturnCompletionBlock:(void (^)(BOOL))completed;

//-(void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex  {
//  UIActionSheetDidDismissWithButtonIndexBlock block = [self.didDismissWithButtonIndexBlock copy];
//  block(actionSheet, buttonIndex);
//  [block release];
//}
//
//typedef void (^UIActionSheetDidDismissWithButtonIndexBlock)(UIActionSheet* actionSheet, NSInteger buttonIndex);
//
//[UIActionSheet actionSheetWithTitle:title
//                              style:UIActionSheetStyleAutomatic
//                  cancelButtonTitle:cancelTitle
//             destructiveButtonTitle:destructiveTitle
//                       buttonTitles:buttonTitles
//                     disabledTitles:disabledTitles
//                         showInView:view
//                          onDismiss:^(int buttonIndex, NSString *buttonTitle){
//                            NSLog(@"Pressed button : %@",buttonTitle);
//                          }
//                           onCancel:^(void){
//                             NSLog(@"UIActionSheet Cancelled");
//                           }];
//
//+ (UIActionSheet *)actionSheetWithTitle:(NSString *)title
//                      cancelButtonTitle:(NSString *)cancelButtonTitle
//                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
//                           buttonTitles:(NSArray *)buttonTitles
//                             showInView:(UIView *)view
//                              onDismiss:(DismissBlock)dismissed
//                               onCancel:(VoidBlock)cancelled;

@end
