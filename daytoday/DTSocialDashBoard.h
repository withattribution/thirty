//
//  DTSocialDashBoard.h
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSocialDashBoardDelegate <NSObject>

@optional
- (void)shouldLike;
- (void)shouldUnLike;
- (void)didSelectComments;
- (void)didSelectShareButton;
@end

@interface DTSocialDashBoard : UIView

@property (nonatomic,weak) id<DTSocialDashBoardDelegate> delegate;

- (void)resetCommentDisplayState;

@end
