//
//  DTSelectionSheet.h
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTSelectionSheetType) {
  DTSelectionSheetDuration,    //dtdot elements for duration
  DTSelectionSheetVerification,//dtdotelements for verification
  DTSelectionSheetRepetition,  //create dtdotelements for number of times a challenge should be repeated in a day
  DTSelectionSheetCategory     //create category objects to select from
//  DTSelectionSheetGeneric    //pass in an array of generic objects to select from
};

@interface DTSelectionSheet : UIView

@property (nonatomic,retain) NSString *titleText;
@property (nonatomic,strong) NSArray *selectionArray;

+ (id)selectionSheetWithType:(DTSelectionSheetType)type;
+ (id)selectionSheetWithTitle:(NSString *)t objects:(NSArray *)objs;

- (id)initWithFrame:(CGRect)frame withType:(DTSelectionSheetType)type;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)t objects:(NSArray *)objs;

//- (id)didCompleteWithSelectedObject:(id (^)(id obj))block;
- (void)didCompleteWithSelectedObject:(void (^)(id obj))block;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
