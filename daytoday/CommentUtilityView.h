//
//  CommentUtilityView.h
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentUtilityViewDelegate <NSObject>

@optional
- (void)didCancelCommentAddition;
- (void)willHandleAttemptToAddComment;
@end


@interface CommentUtilityView : UIView

@property(nonatomic,weak) id<CommentUtilityViewDelegate> delegate;

@end
