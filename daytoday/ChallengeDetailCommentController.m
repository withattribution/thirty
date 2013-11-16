//
//  ChallengeDetailCommentController.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDetailCommentController.h"
#import "DTSocialDashBoard.h"
#import "ChallengeDayCommentTableView.h"
#import "CommentInputView.h"
#import "CommentUtilityView.h"

@interface ChallengeDetailCommentController () <DTSocialDashBoardDelegate,CommentUtilityViewDelegate>

@property (nonatomic,strong) DTSocialDashBoard *socialDashBoard;
@property (nonatomic,strong) ChallengeDayCommentTableView *commentTable;

@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) CommentUtilityView *commentUtility;

@end

@implementation ChallengeDetailCommentController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShowNotification:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardDidShowNotification:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHideNotification:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardDidHideNotification:)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardDidShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardDidHideNotification
                                                object:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor lightGrayColor]];
  
  _socialDashBoard = [[DTSocialDashBoard alloc] init];
  [_socialDashBoard setDelegate:self];
  [_socialDashBoard setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 40.f)];
  [self.view addSubview:_socialDashBoard];
  
  _commentTable = [[ChallengeDayCommentTableView alloc] initWithFrame:
                   CGRectMake(0.,
                              _socialDashBoard.frame.origin.y + _socialDashBoard.frame.size.height,
                              self.view.frame.size.width,
                              240.f - 40.f)];

  [self.view addSubview:self.commentTable];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Comment Utility Delegate Methods

- (void)didCancelCommentAddition
{
  NSLog(@"cancelling comments and shit");
  if ([_delegate respondsToSelector:@selector(resetCommentController)])
    [_delegate resetCommentController];
  
  [self.commentInput shouldResignFirstResponder];
  [self.socialDashBoard resetCommentDisplayState];
}

#pragma mark - DTSocial DashBoard Delegate Methods

- (void)didSelectComments
{
  if ([_delegate respondsToSelector:@selector(willHandleCommentAddition)])
    [_delegate willHandleCommentAddition];
  
  _commentInput = [[CommentInputView alloc] init];
  [self.view addSubview:self.commentInput];
  
  _commentUtility = [[CommentUtilityView alloc] init];
  [_commentUtility setDelegate:self];
  [self.view addSubview:self.commentUtility];
  
  [self.commentInput shouldBeFirstResponder];
}

#pragma mark - UIKeyBoard Notitifications

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
  CGRect boardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  
  NSDictionary *metrics = @{@"commentHeight":@(40.f),@"commentOriginY":@(self.view.frame.size.height - boardRect.size.height - 40.f)};

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentInput]|"
                                                                                  options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                  metrics:metrics
                                                                                    views:@{@"commentInput":_commentInput}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(commentOriginY)-[commentInput(commentHeight)]"
                                                                                  options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                  metrics:metrics
                                                                                    views:@{@"commentInput":_commentInput}]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentUtility]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentUtility":_commentUtility}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[commentUtility(40)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentUtility":_commentUtility}]];
  
  [self.commentInput layoutIfNeeded];
  [self.commentUtility layoutIfNeeded];
  
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

  self.commentUtility.transform = CGAffineTransformMakeTranslation(0, -1*self.commentInput.bounds.size.height);
  self.commentInput.transform = CGAffineTransformMakeTranslation(0, self.commentInput.bounds.size.height);
  
  CGFloat tableOriginHeight = self.commentTable.frame.origin.y;
  
  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     self.commentUtility.transform = CGAffineTransformMakeTranslation(0, 0);
                     self.commentInput.transform = CGAffineTransformMakeTranslation(0, 0);

                     [self.commentTable setFrame:CGRectMake(0., tableOriginHeight, self.view.frame.size.width, self.view.frame.size.height - boardRect.size.height - 40.f - 40.f)];
                     [self.socialDashBoard setAlpha:0.f];
                   }
                   completion:^(BOOL complete){
                     [self.commentTable scrollToLastComment];
                   }];
}

- (void)keyboardDidShowNotification:(NSNotification *)aNotification
{
  NSLog(@"did show");
}


- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
  CGRect boardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  
  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.commentTable setFrame:CGRectMake(0.,
                                                            _socialDashBoard.frame.origin.y + _socialDashBoard.frame.size.height,
                                                            self.view.frame.size.width,
                                                            240.f - 40.f)];
                     [self.commentUtility setAlpha:0.f];
                     [self.commentInput setAlpha:0.f];
                     
                     [self.socialDashBoard setAlpha:1.f];
                   }
                   completion:^(BOOL complete){
//                     [self.commentTable scrollToLastComment];
                     
                     [self.commentUtility removeFromSuperview];
                     [self.commentInput removeFromSuperview];
                   }];
  
}

- (void)keyboardDidHideNotification:(NSNotification *)aNotification
{
  NSLog(@"totally did hide");
}

@end
