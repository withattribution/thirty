//
//  ChallengeDetailContainer.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDetailContainer.h"
#import "ChallengeDetailVerificationController.h"
#import "ChallengeDetailCommentController.h"
#import "FDTakeController.h"

#import "DTSocialDashBoard.h"
#import "CommentInputView.h"
#import "CommentUtilityView.h"

#import "UIImage+Resizing.h"

@interface ChallengeDetailContainer () <UIGestureRecognizerDelegate,
                                          DTSocialDashBoardDelegate,
                                         CommentUtilityViewDelegate,
                                           CommentInputViewDelegate,
                                                      FDTakeDelegate>

@property (nonatomic,strong) ChallengeDetailVerificationController *verficationController;
@property (nonatomic,strong) ChallengeDetailCommentController *commentController;
@property (nonatomic,strong) FDTakeController *takeController;

@property (nonatomic,strong) PFFile *commentImageFile;
@property (nonatomic,strong) PFFile *commentThumbnailFile;
@property (nonatomic,assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic,assign) UIBackgroundTaskIdentifier imagePostBackgroundTaskId;

@property (nonatomic,strong) UIView *headerContainerView;
@property (nonatomic,strong) UIView *footerContainerView;

@property (nonatomic,strong) DTSocialDashBoard *socialDashBoard;
@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) CommentUtilityView *commentUtility;

@property (nonatomic,strong) NSString *challengeDayId;

@property (nonatomic,assign) BOOL commentsAreFullScreen;
@property (nonatomic,assign) BOOL isAddingComment;
@property (nonatomic,assign) BOOL isTakingPhoto;

@property (nonatomic,assign) NSUInteger panningVelocityYThreshold;
@property (nonatomic,assign) CGFloat commentControllerAnchor;

@end

@implementation ChallengeDetailContainer

- (void)dealloc
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

- (id)init
{
  self = [super init];
  if(self){
    [self addChallengeDayInterface];
    
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
  
  return self;
}

- (void)addChallengeDayInterface
{
  _verficationController = [[ChallengeDetailVerificationController alloc] init];
  [self.view addSubview:self.verficationController.view];
  [self addChildViewController:self.verficationController];
  
  [self.verficationController didMoveToParentViewController:self];
  
  _commentController = [[ChallengeDetailCommentController alloc] initWithChallengeDayID:self.challengeDayId];
  
  [self.view addSubview:self.commentController.view];
  [self addChildViewController:self.commentController];
  [self.commentController didMoveToParentViewController:self];
  
  _socialDashBoard = [[DTSocialDashBoard alloc] init];
  [self.socialDashBoard setDelegate:self];
  
  [self setHeaderContainerView:self.socialDashBoard];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[social]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"social":self.socialDashBoard}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[social(40)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"social":self.socialDashBoard}]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerContainerView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.commentController.tableView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:0.f]];
  [self.view layoutIfNeeded];
  
  [self.commentController.view setFrame:CGRectMake(0.f,
                                                   [self.verficationController heightForControllerFold] + 40,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height)];
  self.commentsAreFullScreen = NO;
  self.isAddingComment       = NO;
  self.isTakingPhoto         = NO;

  self.commentControllerAnchor = _commentController.view.frame.origin.y - 40;
  self.panningVelocityYThreshold = 500;
  
  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(moveCommentController:)];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [panRecognizer setCancelsTouchesInView:NO];
  [panRecognizer setDelegate:self];
  
  [self.commentController.view addGestureRecognizer:panRecognizer];
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

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar setHidden:YES];
  [[UIApplication sharedApplication] setStatusBarHidden:self.commentsAreFullScreen];
  NIDINFO(@"CONTAINER WILL APPEAR");
  
//  PFQuery *currentChallengeDay = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
//  
//  [currentChallengeDay whereKey:@"objectId" equalTo:@"v9xN4EbG71"];
//  
//  [currentChallengeDay getObjectInBackgroundWithId:@"v9xN4EbG71" block:^(PFObject *obj, NSError *err){
//    if(!err){
//      self.challengeDayId = obj.objectId;
//      NIDINFO(@"got object id: %@",self.challengeDayId);
//      [self addChallengeDayInterface];
//    }else{
//      NIDINFO(@"%@",[err localizedDescription]);
//    }
//  }];
//  One time only make a challenge day object so that we can reuse the challenge day object id to build out the comment interface
  
//  PFObject *challengeDay = [PFObject objectWithClassName:kDTChallengeDayClassKey];
//  challengeDay[kDTChallengeDayTaskRequiredCountKey] = @3;
//  challengeDay[kDTChallengeDayTaskCompletedCountKey] = @1;
//  challengeDay[kDTChallengeDayOrdinalDayKey] = @14;
//  challengeDay[kDTChallengeDayAccomplishedKey] = @NO;
//  
//  [challengeDay saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//  
//    if (succeeded){
//      NIDINFO(@"succeeded!");
//    }else {
//      NIDINFO(@"%@",[err localizedDescription]);
//    }
//  }];
}

#pragma mark - Comment Input Delegate Methods

- (void)willHandleAttemptToAddComment:(NSString *)commentText
{
  NIDINFO(@"handle comment: %@",commentText);

  NSString *trimmedComment = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  //build and send the photo object then the activity object because it depends on the activity object
  PFObject *comment = [PFObject objectWithClassName:kDTActivityClassKey];
  comment[kDTActivityTypeKey] = kDTActivityTypeComment;
  comment[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:@"40QlXzWWxZ"];
#warning set toUser and FromUser when users exist

  if(self.commentImageFile && self.commentImageFile){
    //adding image
    PFObject *imageObject = [PFObject objectWithClassName:kDTImageClassKey];
#warning should also add user key for image object when we have users
#warning should add ACL here for accessing and privacy settings
    imageObject[kDTImageTypeKey] = kDTImageTypeComment;
    imageObject[kDTImageMediumKey] = self.commentImageFile;
    imageObject[kDTImageSmallKey] = self.commentThumbnailFile;

    self.imagePostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      [[UIApplication sharedApplication] endBackgroundTask:self.imagePostBackgroundTaskId];
    }];

    [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        NIDINFO(@"succeeded uploading image object!");
        //if the comment also has a text field then add that and send
        if (trimmedComment && trimmedComment.length > 0) {
          comment[kDTActivityContentKey] = trimmedComment;
        }
        [comment saveEventually];
      }else {
        NIDINFO(@"%@",[error localizedDescription]);
      }
      [[UIApplication sharedApplication] endBackgroundTask:self.imagePostBackgroundTaskId];
    }];
  }else {
    if (trimmedComment && trimmedComment.length > 0) {
      comment[kDTActivityContentKey] = trimmedComment;
    }
    [comment saveEventually];
  }
}

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
  //cancel any pending transfers
  [self.commentImageFile cancel];
  [self.commentThumbnailFile cancel];
  
  UIImage *croppedImage = [photo cropToSize:CGSizeMake(320.f, 320.f) usingMode:NYXCropModeCenter];
  UIImage *croppedThumbnail = [croppedImage scaleToFitSize:CGSizeMake(85.f, 85.f)];
  
  NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.8f);
  NSData *thumbnailData = UIImageJPEGRepresentation(croppedThumbnail, 0.8f);
  //construct the image files on user selection
  if (imageData && thumbnailData) {
    self.commentImageFile = [PFFile fileWithData:imageData];
    self.commentThumbnailFile = [PFFile fileWithData:thumbnailData];
    
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.commentImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
      if(succeeded){
        NIDINFO(@"succeeded uploading medium image file -- attempting thumbnail image upload");
        [self.commentThumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
          if (succeeded) {
            NIDINFO(@"succeeded uploading thumbnail file");
          }
          [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }];
      }else {
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
      }
    }];
  }
  
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

#pragma mark - Comment Utility Delegates

- (void)didCancelCommentAddition
{
  self.isAddingComment = NO;

  if([self.footerContainerView isKindOfClass:[CommentInputView class]])
    [(CommentInputView *)self.footerContainerView shouldResignFirstResponder];

  [self setHeaderContainerView:self.socialDashBoard];
  [self setFooterContainerView:nil];
}

#pragma mark - DTSocialDashBoard Delegate Methods

- (void)didSelectComments
{
  self.isAddingComment = YES;

  _commentUtility = [[CommentUtilityView alloc] init];
  [self.commentUtility setDelegate:self];
  [self setHeaderContainerView:self.commentUtility];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentUtility]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"commentUtility":self.commentUtility}]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[commentUtility(36)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"commentUtility":self.commentUtility}]];
  _commentInput = [[CommentInputView alloc] init];
  [self.commentInput setDelegate:self];
  [self setFooterContainerView:self.commentInput];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[commentInput]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"commentInput":self.commentInput}]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentInput(50)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:nil
                                                                      views:@{@"commentInput":self.commentInput}]];

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.footerContainerView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.commentController.tableView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f]];
  [self.view layoutIfNeeded];

  if([self.footerContainerView isKindOfClass:[CommentInputView class]])
    [(CommentInputView *)self.footerContainerView shouldBeFirstResponder];
}

#pragma mark - Header/Footer Helper Methods

- (void)cleanUpCommentSubmissionInterface
{
  [self.commentUtility removeFromSuperview];
  [self.commentInput removeFromSuperview];
  self.commentInput   = nil;
  self.commentUtility = nil;
}

- (void)setFooterContainerView:(UIView *)footerContainerView
{
  if(!footerContainerView){
    //clean up comment interface
    [self cleanUpCommentSubmissionInterface];
    return;
  }
  
  if (_footerContainerView && footerContainerView.superview) {
    [_footerContainerView setHidden:YES];
    _footerContainerView = footerContainerView;
    [_footerContainerView setHidden:NO];
  }else{
    _footerContainerView = footerContainerView;
    [self.view addSubview:_footerContainerView];
  }
}

- (void)setHeaderContainerView:(UIView *)headerContainerView
{
  if (_headerContainerView && headerContainerView.superview) {
    [_headerContainerView setHidden:YES];
    _headerContainerView = headerContainerView;
    [_headerContainerView setHidden:NO];
  }else {
    [_headerContainerView setHidden:YES];
    _headerContainerView = headerContainerView;
    [_headerContainerView setHidden:NO];
    [self.view addSubview:_headerContainerView];
  }
}

#pragma mark - Handle Panning Comment Controller

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    //    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view];
    if (self.commentsAreFullScreen && self.isAddingComment) {
      return NO;
    }
    return YES;
  }
  return YES;
}

- (void)moveCommentController:(UIPanGestureRecognizer *)recognizer
{
  [[[(UITapGestureRecognizer*)recognizer view] layer] removeAllAnimations];
  
  CGPoint translatedPoint = [recognizer translationInView:self.view];
  
  if([recognizer state] == UIGestureRecognizerStateBegan) {
    [[recognizer view] bringSubviewToFront:[recognizer view]];
  }
  
  if([recognizer state] == UIGestureRecognizerStateEnded) {
    CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
    
    
    CGFloat currentVelocityY = currentVelocityPoint.y;
    BOOL viewIsPastAnchor = ([recognizer locationInView:self.view].y <= self.commentControllerAnchor);
    
    if(viewIsPastAnchor || abs(currentVelocityY) > self.panningVelocityYThreshold)
    {
      if(self.commentsAreFullScreen && currentVelocityY < 0)
        [self moveControllerToTopWithOptions:nil];
      if(self.commentsAreFullScreen && currentVelocityY > 0)
        [self moveControllerToOriginalPositionWithOptions:nil];
      else if(currentVelocityY < 0)
        [self moveControllerToTopWithOptions:nil];
      else
        [self moveControllerToOriginalPositionWithOptions:nil];
    }
    else
      [self moveControllerToOriginalPositionWithOptions:nil];
  }
  
  if([recognizer state] == UIGestureRecognizerStateChanged) {
    [recognizer view].center = CGPointMake([recognizer view].center.x, [recognizer view].center.y + translatedPoint.y);
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
  }
}

#pragma mark - Comment Controller Display Animations

- (void)moveControllerToTopWithOptions:(NSDictionary *)options
{
  CGFloat keyboardHeight = [[options objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
  CGFloat headerContainerHeight = self.headerContainerView.frame.size.height;
  CGFloat footerContainerHeight = self.footerContainerView.frame.size.height;
  
  [UIView animateWithDuration:.32f
                        delay:0
                      options:(UIViewAnimationOptionBeginFromCurrentState| UIViewAnimationCurveEaseOut)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     self.commentController.view.frame = CGRectMake(0.f,
                                                                headerContainerHeight,
                                                                self.view.frame.size.width,
                                                                    (self.isAddingComment && options)
                                                                    ? self.view.frame.size.height - keyboardHeight - headerContainerHeight - footerContainerHeight
                                                                    : self.view.frame.size.height - headerContainerHeight);
                     [[UIApplication sharedApplication] setStatusBarHidden:YES];
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       self.commentsAreFullScreen = YES;
                     }
                   }];
}

-(void)moveControllerToOriginalPositionWithOptions:(NSDictionary *)options
{
  CGFloat footerContainerHeight = self.footerContainerView.frame.size.height;

	[UIView animateWithDuration:.32f
                        delay:0
                      options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     self.commentController.view.frame = CGRectMake(0.f,
                                                                [self.verficationController heightForControllerFold] + footerContainerHeight,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height - [self.verficationController heightForControllerFold]);
                     [[UIApplication sharedApplication] setStatusBarHidden:NO];
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       self.commentsAreFullScreen = NO;
                     }
                   }];
}

#pragma mark - UIKeyBoard Notitifications

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
  if (self.isAddingComment) {
    [self moveControllerToTopWithOptions:aNotification.userInfo];
  }
}

- (void)keyboardDidShowNotification:(NSNotification *)aNotification
{
//  NSLog(@"KEYBOARD UP");
}

- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
  if (!self.isAddingComment) {
    [self moveControllerToOriginalPositionWithOptions:aNotification.userInfo];
  }
}

- (void)keyboardDidHideNotification:(NSNotification *)aNotification
{
//  NSLog(@"KEYBOARD DOWN");
}
@end
