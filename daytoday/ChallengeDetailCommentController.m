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


@interface ChallengeDetailCommentController () <DTSocialDashBoardDelegate>

@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) ChallengeDayCommentTableView *commentTable;

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
  
  DTSocialDashBoard *social = [[DTSocialDashBoard alloc] init];
  [social setDelegate:self];
  [social setFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
  [self.view addSubview:social];
  
  _commentTable = [[ChallengeDayCommentTableView alloc] initWithFrame:
                   CGRectMake(0.,
                              social.frame.origin.y + social.frame.size.height,
                              self.view.frame.size.width,
                              480.f - 50.f)];

  [self.view addSubview:self.commentTable];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - DTSocialDashBoardDelegate

- (void)didSelectComments
{
  if ([_delegate respondsToSelector:@selector(willHandleCommentAddition)])
    [_delegate willHandleCommentAddition];
  
  _commentInput = [[CommentInputView alloc] init];
  [self.view addSubview:self.commentInput];
  [self.commentInput shouldBeFirstResponder];
}

#pragma mark - UIKeyBoard Notitifications

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
  CGRect boardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  
  NSDictionary *metrics = @{@"commentHeight":@(40.f),@"commentOriginY":@(self.view.frame.size.height - boardRect.size.height - 40.f)};

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentInput]|"
                                                                                  options:NSLayoutFormatAlignAllCenterY
                                                                                  metrics:metrics
                                                                                    views:@{@"commentInput":_commentInput}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(commentOriginY)-[commentInput(commentHeight)]"
                                                                                  options:NSLayoutFormatAlignAllCenterY
                                                                                  metrics:metrics
                                                                                    views:@{@"commentInput":_commentInput}]];
  
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

  self.commentInput.transform = CGAffineTransformMakeTranslation(0, self.commentInput.bounds.size.height);
  
  CGFloat tableOriginHeight = self.commentTable.frame.origin.y;
  
  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.commentInput layoutIfNeeded];

                     self.commentInput.transform = CGAffineTransformMakeTranslation(0, 0);
                     [self.commentTable setFrame:CGRectMake(0., tableOriginHeight, self.view.frame.size.width, self.view.frame.size.height - boardRect.size.height - 40.f - 50.f)];
                     [self.commentTable scrollToLastComment];
                   }
                   completion:^(BOOL complete){
                   }];
}

- (void)keyboardDidShowNotification:(NSNotification *)aNotification
{
  NSLog(@"did show");
}


- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
  g
}

- (void)keyboardDidHideNotification:(NSNotification *)aNotification
{
  NSLog(@"totally did hide");
}

@end
