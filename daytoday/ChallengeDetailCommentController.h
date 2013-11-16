//
//  ChallengeDetailCommentController.h
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChallengeDetailCommentControllerDelegate <NSObject>
@optional

- (void)willHandleCommentAddition;
- (void)resetCommentController;

@end

@interface ChallengeDetailCommentController : UIViewController

@property (nonatomic,weak) id<ChallengeDetailCommentControllerDelegate> delegate;

@end
