//
//  DTSocialDashBoard.h
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTSocialDashBoard;
@protocol DTSocialDashBoardDelegate <NSObject>

@optional
- (void)didTapLikeButtonFromDTSocialDashBoard:(DTSocialDashBoard *)dashBoard shouldLike:(BOOL)like;
- (void)didSelectComments;
- (void)didSelectShareButton;
@end

@interface DTSocialDashBoard : UIView

@property (nonatomic,weak) id<DTSocialDashBoardDelegate> delegate;

@property (nonatomic,strong) NSNumber *likeCount;
@property (nonatomic,strong) NSNumber *commentCount;

//- (void)resetCommentDisplayState;

@end
