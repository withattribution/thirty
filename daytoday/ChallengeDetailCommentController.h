//
//  ChallengeDetailCommentController.h
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChallengeDayCommentTableView;

@protocol ChallengeDetailCommentControllerDelegate <NSObject>
@optional

- (void)willHandleCommentAddition;
- (void)resetCommentController;

@end

@interface ChallengeDetailCommentController : UIViewController

@property (nonatomic,strong) ChallengeDayCommentTableView *commentTable;
@property (nonatomic,weak) id<ChallengeDetailCommentControllerDelegate> delegate;

@end
