//
//  DTVerificationElement.h
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTVerificationElement;
@protocol DTVerificationElementDataSource <NSObject>
@required
- (NSUInteger)numberOfSectionsInVerificationElement:(DTVerificationElement *)verificationElement;
@end


@interface DTVerificationElement : UIView
@property (nonatomic,weak) id<DTVerificationElementDataSource> dataSource;

@property (nonatomic,assign) CGFloat dotRadius;
@property (nonatomic,assign) CGPoint dotCenter;
@property (nonatomic,assign) CGFloat startSectionAngle;
@property (nonatomic,assign) CGFloat animationSpeed;

- (void)reloadData;

@end
