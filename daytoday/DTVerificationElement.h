//
//  DTVerificationElement.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTVerificationElement;
@protocol DTVerificationElementDataSource <NSObject>
@required
- (NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement;
- (NSUInteger)numberOfCompletedSectionsInVerificationElement:(DTVerificationElement *)element;
@end

@protocol DTVerificationElementDelegate <NSObject>
@optional
- (void)verificationElement:(DTVerificationElement*)element didVerifySection:(NSUInteger)section;
@end

@interface DTVerificationElement : UIView
@property (nonatomic,weak) id<DTVerificationElementDataSource> dataSource;
@property (nonatomic,weak) id<DTVerificationElementDelegate> delegate;
@property (nonatomic,assign) CGFloat dotRadius;
@property (nonatomic,assign) CGPoint dotCenter;
@property (nonatomic,assign) CGFloat startSectionAngle;
@property (nonatomic,assign) CGFloat animationSpeed;

- (void)reloadData:(BOOL)animated;

@end
