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
#import "FDTakeController.h"

#import "UIImage+Resizing.h"


@interface ChallengeDetailCommentController () <DTSocialDashBoardDelegate,CommentUtilityViewDelegate,CommentInputViewDelegate,FDTakeDelegate>
{
  NSLayoutConstraint * _inputTopConstraint;
}
@property (nonatomic,strong) DTSocialDashBoard *socialDashBoard;

@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) CommentUtilityView *commentUtility;

@property (nonatomic,strong) FDTakeController *takeController;

@property (nonatomic,strong) PFFile *commentImageFile;
@property (nonatomic,strong) PFFile *commentThumbnailFile;

@property (nonatomic,assign) BOOL isTakingPhoto;
@property (nonatomic,assign) BOOL isEnteringComment;
@property (nonatomic,assign) BOOL shouldLayoutCommentInterface;

@end

@implementation ChallengeDetailCommentController

- (void)dealloc
{
  [self removeKeyBoardNotifications];
}

- (id)init
{
    self = [super init];
    if (self) {
      self.isTakingPhoto = NO;
      self.shouldLayoutCommentInterface = NO;
      self.isEnteringComment = NO;
      
      [self.view setBackgroundColor:[UIColor lightGrayColor]];
      
      _socialDashBoard = [[DTSocialDashBoard alloc] init];
      [_socialDashBoard setDelegate:self];
      [_socialDashBoard setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 40.f)];
      [self.view addSubview:self.socialDashBoard];
      
      _commentTable = [[ChallengeDayCommentTableView alloc] initWithFrame:
                       CGRectMake(0.,
                                  _socialDashBoard.frame.origin.y + _socialDashBoard.frame.size.height,
                                  self.view.frame.size.width,
                                  240.f - 40.f)];
      
      [self.view addSubview:self.commentTable];
      
      [self addKeyBoardNotifications];
    }
    return self;
}

- (void)willHandleAttemptToAddComment
{
  PFObject *comment = [PFObject objectWithClassName:kDTActivityClassKey];
  
  [comment addObject:kDTActivityTypeChallengeCreation forKey:kDTActivityTypeKey];
  [comment addObject:@"this is another comment again" forKey:kDTActivityContentKey];
  
  [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
  
    if (succeeded) {
      NIDINFO(@"you know it!");
      PFQuery *query = [PFQuery queryWithClassName:kDTActivityClassKey];
      
      [query whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeComment];
      [query findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error){
        if (!error) {
          NSLog(@"object count: %d",[objs count]);
          for (PFObject *ob in objs) {
            NIDINFO(@"the comment: %@", [ob objectForKey:kDTActivityContentKey]);
          }
        }
        else {
          NIDINFO(@"%@",[error localizedDescription]);
        }
      }];
      
    }
    else {
      NIDINFO(@"%@",[error localizedDescription]);
    }
  
  }];
}

#pragma mark - UIViewController Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  NIDINFO(@"<><><><> VIEW IS ABOUT TO DISAPPEAR! <><><><>");
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)addKeyBoardNotifications
{
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

- (void)removeKeyBoardNotifications
{
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

#pragma mark - Comment Utility Delegate Methods

- (void)didCancelCommentAddition
{
  NSLog(@"cancelling comments and shit");
  if ([_delegate respondsToSelector:@selector(resetCommentController)])
    [_delegate resetCommentController];
  
  [self.commentInput shouldResignFirstResponder];
  [self cleanUpCommentSubmissionInterface];
  [self.socialDashBoard resetCommentDisplayState];
  self.isEnteringComment = NO;
}

#pragma mark - Comment Input Delegate Methods

- (void)didSelectPhotoInput
{
  //tells the keyboard notifications to just change the keyboard presentation state and dont mess with anything else
  self.isTakingPhoto = YES;

  [self.commentInput shouldResignFirstResponder];
  
  if (!self.takeController) {
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    self.takeController.viewControllerForPresentingImagePickerController = self;
  }
  
  [self.takeController takePhotoOrChooseFromLibrary];
}

#pragma mark - FDTake Delegate Methods

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
  NIDINFO(@"got the photo here it is: %@, and info: %@",photo,info);

  //cancel any pending transfers
  [self.commentImageFile cancel];
  [self.commentThumbnailFile cancel];
  
  UIImage *croppedImage = [photo cropToSize:CGSizeMake(320.f, 320.f) usingMode:NYXCropModeCenter];
  UIImage *croppedThumbnail = [croppedImage scaleToFitSize:CGSizeMake(85.f, 85.f)];
  
  //construct the image files on selection
  
  NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.8f);
  NSData *thumbnailData = UIImageJPEGRepresentation(croppedThumbnail, 0.8f);
  
  if (imageData && thumbnailData) {
    self.commentImageFile = [PFFile fileWithData:imageData];
    self.commentThumbnailFile = [PFFile fileWithData:thumbnailData];
    
    [self.commentImageFile saveInBackground];
    [self.commentThumbnailFile saveInBackground];
  }
  
  NIDINFO(@"the thumbnail image :%@",CGSizeCreateDictionaryRepresentation(croppedThumbnail.size));
  
  self.isTakingPhoto = NO;
  [self.commentInput placeImageThumbnailPreview:croppedThumbnail];
  
  [self.commentInput shouldBeFirstResponder];
}

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
  NIDINFO(@"cancelled with attempt? %d",madeAttempt);
  self.isTakingPhoto = NO;
  [self.commentInput shouldBeFirstResponder];
  //if cancelled the user should still be in the comment entering mode and should cancel that on their own
}

- (void)takeController:(FDTakeController *)controller didFailAfterAttempting:(BOOL)madeAttempt
{
  NIDINFO(@"failed with attempt? %d",madeAttempt);
  self.isTakingPhoto = NO;
}


#pragma mark - DTSocial DashBoard Delegate Methods

- (void)didSelectComments
{
  self.isTakingPhoto = NO;
  self.shouldLayoutCommentInterface = YES;
  self.isEnteringComment = YES;

  if ([_delegate respondsToSelector:@selector(willHandleCommentAddition)])
    [_delegate willHandleCommentAddition];

  if(!self.commentInput){
    NSLog(@"<<<<<<<<<<< ADDING COMMENT INPUT >>>>>>>>>>>>>>>");
    _commentInput = [[CommentInputView alloc] init];
    [_commentInput setDelegate:self];
    [self.view addSubview:self.commentInput];
  }

  if(!self.commentUtility){
    _commentUtility = [[CommentUtilityView alloc] init];
    [_commentUtility setDelegate:self];
    [self.view addSubview:self.commentUtility];
  }

  [self.commentInput shouldBeFirstResponder];
}

#pragma mark - UIKeyBoard Notitifications

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
  CGRect boardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  
  if (self.shouldLayoutCommentInterface) {
    [self layoutCommentInterfaceForKeyBoardRect:boardRect];
  }

  if (!self.isTakingPhoto) {
    [self presentCommentSubmissionInterfaceWith:duration andAnimationCurve:curve andKeyBoardFrame:boardRect];
  }
}

- (void)layoutCommentInterfaceForKeyBoardRect:(CGRect)kBoard
{
  NSDictionary *metrics = @{@"commentHeight":@(50.f),@"commentOriginY":@(self.view.frame.size.height - kBoard.size.height - 50.f)};
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentInput]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentInput":_commentInput}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentInput(50)]"
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
  [self.view layoutIfNeeded];
}


- (void)presentCommentSubmissionInterfaceWith:(NSNumber *)duration andAnimationCurve:(NSNumber *)curve andKeyBoardFrame:(CGRect)kBoardFrame
{
  CGFloat tableOriginHeight = self.commentTable.frame.origin.y;
  
  [self.view removeConstraint:_inputTopConstraint];
  
  _inputTopConstraint = [NSLayoutConstraint constraintWithItem:self.commentInput
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:kBoardFrame.size.height-2.f];
  
  [self.view addConstraint:_inputTopConstraint];
  
  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     [self.commentTable setFrame: (self.isEnteringComment) ?
                      CGRectMake(0.,
                                 tableOriginHeight,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height - kBoardFrame.size.height - 40.f - 50.f) :
                      CGRectMake(0.,
                                 40.f,
                                 self.view.frame.size.width,
                                 240.f - 40.f)];
                     
//                     [self.commentTable setFrame:CGRectMake(0.,
//                                                            tableOriginHeight,
//                                                            self.view.frame.size.width,
//                                                            self.view.frame.size.height - kBoardFrame.size.height - 40.f - 40.f)];
                     [self.socialDashBoard setAlpha:0.f];
                   }
                   completion:^(BOOL complete){
//                     [self.commentTable scrollToLastComment];
                   }];
}

- (void)keyboardDidShowNotification:(NSNotification *)aNotification
{
  NSLog(@"KEYBOARD UP");
}


- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
  CGRect boardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  
  [self.view removeConstraint:_inputTopConstraint];
  
  _inputTopConstraint = [NSLayoutConstraint constraintWithItem:self.commentInput
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:480.f];
  
  [self.view addConstraint:_inputTopConstraint];
  
  CGFloat tableOriginHeight = self.commentTable.frame.origin.y;

  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     [self.commentTable setFrame: (self.isEnteringComment) ?
                                                  CGRectMake(0.,
                                                             tableOriginHeight,
                                                             self.view.frame.size.width,
                                                             self.view.frame.size.height - 40.f) :
                                                  CGRectMake(0.,
                                                             40.f,
                                                             self.view.frame.size.width,
                                                             240.f - 40.f)];
                     
                     if (!self.isTakingPhoto) {
                       [self.commentUtility setAlpha:0.f];
                       [self.commentInput setAlpha:0.f];

                       
                       [self.socialDashBoard setAlpha:1.f];
                     }
                   }
                   completion:^(BOOL complete){
//                     NIDINFO(@"where did the fucking table go? %@",CGRectCreateDictionaryRepresentation(self.commentTable.frame));
                   }];
  
  
  
//  if (!self.isTakingPhoto) {
//    [self dismissCommentSubmissionInterfaceWith:duration andAnimationCurve:curve andKeyBoardFrame:boardRect];
//  }
}

//- (void)dismissCommentSubmissionInterfaceWith:(NSNumber *)duration andAnimationCurve:(NSNumber *)curve andKeyBoardFrame:(CGRect)kBoardFrame
//{
//  [UIView animateWithDuration:[duration doubleValue]
//                        delay:0.f
//                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
//                   animations:^{
//                       [self.commentUtility setAlpha:0.f];
//                       [self.commentInput setAlpha:0.f];
//                       
//                       [self.socialDashBoard setAlpha:1.f];
//                   }
//                   completion:^(BOOL complete){
//                     [self.commentTable scrollToLastComment];
//
//                   }];
//}

- (void)cleanUpCommentSubmissionInterface
{
  [UIView animateWithDuration:.35
                   animations:^{
                     [self.commentUtility setAlpha:0.f];
                     [self.commentInput setAlpha:0.f];
                     
                     [self.socialDashBoard setAlpha:1.f];
                   }
                   completion:^(BOOL complete){

                     [self.commentUtility removeFromSuperview];
                     [self.commentInput removeFromSuperview];
                     self.commentInput  = nil;
                     self.commentUtility = nil;
                   }];

  NIDINFO(@"<<<<<<<< removed comment interface from superview!! >>>>>>>>>");
}


- (void)keyboardDidHideNotification:(NSNotification *)aNotification
{
  NSLog(@"KEYBOARD DOWN");
}

@end
