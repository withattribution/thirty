//
//  ChallengeDetailCommentController.h
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ChallengeDetailCommentControllerDelegate <NSObject>
//@optional
//
//- (void)willHandleCommentAddition;
//- (void)resetCommentController;
//
//@end

@interface ChallengeDetailCommentController : UITableViewController

//@property (nonatomic,weak) id<ChallengeDetailCommentControllerDelegate> delegate;

- (id)initWithChallengeDayID:(NSString *)challengeDayId;



//- (void)scrollToLastComment;
//
//- (void)scrollToLastComment
//{
//  NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:[self.rowData indexOfObject:[self.rowData lastObject]]
//                                                    inSection:[self.sectionData indexOfObject:[self.sectionData lastObject]]];
//  
//  [self scrollToRowAtIndexPath:bottomIndexPath
//              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}

@end


