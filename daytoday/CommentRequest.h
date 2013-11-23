//
//  CommentRequest.h
//  daytoday
//
//  Created by Anderson Miller on 8/24/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "D2Request.h"
#import "Comment+D2D.h"
#import "ChallengeDay+D2D.h"

@protocol CommentRequestDelegate <D2RequestDelegate>
- (void) createdComment:(Comment*)comment;
- (void) deletedComment;
@end

@interface CommentRequest : D2Request
@property(nonatomic,weak) id <CommentRequestDelegate> delegate;
- (void) createComment:(ChallengeDay*)cd comment:(NSString*)comment;
- (void) deleteComment:(NSNumber*)commentId;
@end
