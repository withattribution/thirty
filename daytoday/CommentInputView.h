//
//  CommentInputView.h
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentInputViewDelegate <NSObject>

- (void)didSelectPhotoInput;
- (void)willHandleAttemptToAddComment:(NSString *)commentText;

@end

@interface CommentInputView : UIView

@property (nonatomic,weak) id<CommentInputViewDelegate> delegate;

- (void)placeImageThumbnailPreview:(UIImage *)previewImage;

- (void)shouldBeFirstResponder;
- (void)shouldResignFirstResponder;

@end
