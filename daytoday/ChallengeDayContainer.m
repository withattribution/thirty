//
//  ChallengeDayContainer.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDayContainer.h"
#import "ChallengeDayVerificationController.h"
#import "ChallengeDayCommentController.h"
#import "ProfileViewController.h"
#import "FDTakeController.h"

#import "DTSocialDashBoard.h"
#import "CommentInputView.h"
#import "CommentUtilityView.h"

#import "UIImage+Resizing.h"

//#import "DTGlobalNavigation.h"
#import "DTNavigationBar.h"

#import "VerificationFlowController.h"
//#import "SWRevealViewController.h"

@interface ChallengeDayContainer () <UIGestureRecognizerDelegate,
                                          DTSocialDashBoardDelegate,
                                         CommentUtilityViewDelegate,
                                           CommentInputViewDelegate,
                                                     FDTakeDelegate,
                                            DTNavigationBarDelegate,
                                          DTGlobalNavigationDelegate>

@property (nonatomic,strong) ChallengeDetailVerificationController *verficationController;
@property (nonatomic,strong) ChallengeDayCommentController *commentController;
@property (nonatomic,strong) FDTakeController *takeController;

@property (nonatomic,strong) PFFile *commentImageFile;
@property (nonatomic,strong) PFFile *commentThumbnailFile;
@property (nonatomic,assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic,assign) UIBackgroundTaskIdentifier imagePostBackgroundTaskId;

@property (nonatomic,strong) UIView *headerContainerView;
@property (nonatomic,strong) UIView *footerContainerView;

@property (nonatomic,strong) DTNavigationBar *navigationBar;
@property (nonatomic,strong) DTSocialDashBoard *socialDashBoard;
@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) CommentUtilityView *commentUtility;

@property (nonatomic,strong) PFObject *challengeDay;

@property (nonatomic,assign) BOOL commentsAreFullScreen;
@property (nonatomic,assign) BOOL isAddingComment;

@property (nonatomic,assign) NSUInteger panningVelocityYThreshold;
@property (nonatomic,assign) CGFloat commentControllerAnchor;

@end

@implementation ChallengeDayContainer

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTChallengeDayRetrievedNotification
                                                object:nil];
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
  if(self)
  {
    self.commentsAreFullScreen = NO;
    self.isAddingComment       = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRetrieveChallengeDay:)
                                                 name:DTChallengeDayRetrievedNotification
                                               object:nil];
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

- (void) willMoveToParentViewController:(UIViewController *)parent
{
  [super willMoveToParentViewController:parent];
  
  if ([parent isKindOfClass:[VerificationFlowController class]]) {
    [self.verficationController viewWillAppear:NO];
    [self.commentController loadObjects];
  }
}

- (void)addChallengeDayInterface
{
  _verficationController = [[ChallengeDetailVerificationController alloc] initWithChallengeDay:self.challengeDay];
  [self.view addSubview:self.verficationController.view];
  [self addChildViewController:self.verficationController];

  [self.verficationController didMoveToParentViewController:self];

#warning this does not allow for other users to view other challenges

  PFObject *intent = [[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]];
  PFObject *challenge = [[[[PFUser currentUser] objectForKey:kDTUserActiveIntent] objectForKey:kDTIntentChallengeKey] fetchIfNeeded];
  [[DTCache sharedCache] cacheChallenge:challenge forIntent:intent];

#warning this does not allow for other users to view other challenges
  
  self.navigationBar = [[DTNavigationBar alloc] initWithFrame:CGRectMake(0.f,[self padWithStatusBarHeight],self.view.frame.size.width,0.f)];
  [self.view addSubview:self.navigationBar];
  [self.navigationBar setDelegate:self];
  [self.navigationBar setContentText:[challenge objectForKey:kDTChallengeNameKey]];

  
  _commentController = [[ChallengeDayCommentController alloc] initWithChallengeDay:self.challengeDay];

  [self.view addSubview:self.commentController.view];
  [self addChildViewController:self.commentController];
  [self.commentController didMoveToParentViewController:self];
  
  [self.commentController.view setFrame:CGRectMake(0.f,
                                                   [self.verficationController heightForControllerFold] + 0.f,//40.f,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height)];

  self.commentControllerAnchor = _commentController.view.frame.origin.y - 0.f;//40;
  self.panningVelocityYThreshold = 500;

  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(moveCommentController:)];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [panRecognizer setCancelsTouchesInView:NO];
  [panRecognizer setDelegate:self];

  [self.commentController.view addGestureRecognizer:panRecognizer];

  self.globalNavigation = [DTGlobalNavigation globalNavigationWithType:DTGlobalNavTypeSocial];
  [self.globalNavigation setDelegate:self];
  [self.globalNavigation setInsetWidth:5.f];
  [self.globalNavigation setHeartButtonState:[[DTCache sharedCache] isChallengeDayLikedByCurrentUser:self.challengeDay]];
  [self.globalNavigation.fomoButton setHidden:([[[intent objectForKey:kDTIntentChallengeKey] objectId] isEqualToString:[challenge objectId]])];
  
  [self.view addSubview:self.globalNavigation];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [DTCommonRequests activeDayForDate:[NSDate date] user:[PFUser currentUser]];
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
}

#pragma mark - Comment Input Delegate Methods

- (void)willHandleAttemptToAddComment:(NSString *)commentText
{
  NIDINFO(@"handle comment: %@",commentText);
  NSString *trimmedComment = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  //build and send the Image(s) object then the activity object
  //because Image class depends on the activity object
  PFObject *comment = [PFObject objectWithClassName:kDTActivityClassKey];
  comment[kDTActivityTypeKey] = kDTActivityTypeComment;
  comment[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:self.challengeDay.objectId];
  comment[kDTActivityFromUserKey] = [PFUser currentUser];
#warning need to replace method for getting TO USER --> use a stored intent
  comment[kDTActivityToUserKey]   = [PFUser currentUser];//[[self.challengeDay objectForKey:kDTChallengeDayIntentKey] objectForKey:kDTIntentUserKey];

  if(self.commentImageFile && self.commentImageFile){
    //adding image
    PFObject *imageObject = [PFObject objectWithClassName:kDTImageClassKey];
    imageObject[kDTImageTypeKey] = kDTImageTypeComment;
    imageObject[kDTImageMediumKey] = self.commentImageFile;
    imageObject[kDTImageSmallKey] = self.commentThumbnailFile;
    imageObject[kDTImageUserKey] = [PFObject objectWithoutDataWithClassName:[PFUser parseClassName] objectId:[[PFUser currentUser] objectId]];

    PFACL *imageACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [imageACL setPublicReadAccess:YES];
    imageObject.ACL = imageACL;

    self.imagePostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      [[UIApplication sharedApplication] endBackgroundTask:self.imagePostBackgroundTaskId];
    }];

    [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        NIDINFO(@"succeeded uploading image object!");
        //if the comment also has a text field then add that and send
        [comment setObject:imageObject forKey:kDTActivityImageKey];

        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        comment.ACL = ACL;

        if (trimmedComment && trimmedComment.length > 0) {
          comment[kDTActivityContentKey] = trimmedComment;
        }
        [comment saveEventually:^(BOOL succeeded, NSError *error){
          if (succeeded) {
            [self.commentController loadObjects];

            [self didCancelCommentAddition];
          }else {
            NIDINFO(@"%@",[error localizedDescription]);
          }
        }];
      }else {
        NIDINFO(@"%@",[error localizedDescription]);
      }
      [[UIApplication sharedApplication] endBackgroundTask:self.imagePostBackgroundTaskId];
    }];
  }else {
    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    comment.ACL = ACL;

    if (trimmedComment && trimmedComment.length > 0) {
      comment[kDTActivityContentKey] = trimmedComment;
    }
    [comment saveEventually:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        [self.commentController loadObjects];

        [self didCancelCommentAddition];
      }else {
        NIDINFO(@"%@",[error localizedDescription]);
      }
    }];
  }
}

- (void)didSelectPhotoInput
{
  //since the keyboard is misbehaving...
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
  [self.commentInput placeImageThumbnailPreview:croppedThumbnail];
  [self.commentInput shouldBeFirstResponder];
}

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
  NIDINFO(@"cancelled with attempt? %d",madeAttempt);
  [self.commentInput shouldBeFirstResponder];
  //if cancelled the user should still be in the comment entering mode and should cancel that on their own
}

- (void)takeController:(FDTakeController *)controller didFailAfterAttempting:(BOOL)madeAttempt
{
  NIDINFO(@"failed with attempt? %d",madeAttempt);
}

#pragma mark - Comment Utility Delegates

- (void)didCancelCommentAddition
{
  self.isAddingComment = NO;

  if([self.footerContainerView isKindOfClass:[CommentInputView class]])
    [(CommentInputView *)self.footerContainerView shouldResignFirstResponder];

  [self setHeaderContainerView:self.socialDashBoard];
  [self setFooterContainerView:nil];
  
  [self cleanUpCommentSubmissionInterface];
}

#pragma mark - DTSocialDashBoard Delegate Methods

- (void)didTapLikeAction
{
  [self.globalNavigation.heartButton setUserInteractionEnabled:NO];
  
  if (![[DTCache sharedCache] isChallengeDayLikedByCurrentUser:self.challengeDay]) {
    [[DTCache sharedCache] incrementLikeCountForChallengeDay:self.challengeDay];
    [self.globalNavigation setHeartButtonState:YES];
    [DTCommonRequests likeChallengeDayInBackGround:self.challengeDay block:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        NIDINFO(@"liked");
        //- (void)setChallengeDayIsLikedByCurrentUser:(PFObject *)challengeDay liked:(BOOL)liked
        [[DTCache sharedCache] setChallengeDayIsLikedByCurrentUser:self.challengeDay liked:YES];
      }else{
        NIDINFO(@"%@",[error localizedDescription]);
      }
      [self.globalNavigation.heartButton setUserInteractionEnabled:YES];
    }];
  }else {
    [[DTCache sharedCache] decrementLikeCountForChallengeDay:self.challengeDay];
    [self.globalNavigation setHeartButtonState:NO];
    [DTCommonRequests unLikeChallengeDayInBackGround:self.challengeDay block:^(BOOL succeeded, NSError *error){
      if (succeeded) {
        NIDINFO(@"unliked");
        [[DTCache sharedCache] setChallengeDayIsLikedByCurrentUser:self.challengeDay liked:NO];
      }else{
        NIDINFO(@"%@",[error localizedDescription]);
      }
      [self.globalNavigation.heartButton setUserInteractionEnabled:YES];
    }];
  }
}

- (void)didTapCommentAction
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
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
  
  if([recognizer state] == UIGestureRecognizerStateEnded)
  {
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
  CGFloat footerContainerHeight = self.footerContainerView.frame.size.height;
  
  [UIView animateWithDuration:.32f
                        delay:0
                      options:(UIViewAnimationOptionBeginFromCurrentState| UIViewAnimationCurveEaseOut)
                   animations:^{
                     [self.view layoutIfNeeded];
                     self.commentController.view.frame = CGRectMake(0.f,
                                                                    0.f,
                                                                    self.view.frame.size.width,
                                                                    (self.isAddingComment && options)
                                                                    ? self.view.frame.size.height-keyboardHeight-footerContainerHeight
                                                                    : self.view.frame.size.height);
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
	[UIView animateWithDuration:.32f
                        delay:0
                      options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     self.commentController.view.frame = CGRectMake(0.f,
                                                                [self.verficationController heightForControllerFold],
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

- (BOOL)hasActiveIntent
{
  return [[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] != nil;
}

- (void)userDidTapGlobalNavigationButtonType:(DTGlobalButtonType)type
{
  SWRevealViewController *revealController = self.revealController;

  switch (type) {
    case DTGlobalButtonTypeGlobal:
      [revealController revealToggle:self];
      break;
    case DTGlobalButtonTypeFomo:
      break;
    case DTGlobalButtonTypeComment:
      [self didTapCommentAction];
      break;
    case DTGlobalButtonTypeShare:
      break;
    case DTGlobalButtonTypeHeart:
      [self didTapLikeAction];
      break;
  }
}

#pragma mark - DTChallengeDayRetrieved Notifications

- (void)didRetrieveChallengeDay:(NSNotification *)aNotification
{
  if (aNotification.object && aNotification.object != [NSNull null])
  {
    self.challengeDay = (PFObject *)aNotification.object;

    if (![self hasActiveIntent]) {
      [DTCommonRequests queryActiveIntent:[PFUser currentUser]];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(cachedIntentsForUser:)
                                                   name:DTIntentDidCacheIntentForUserNotification
                                                 object:nil];
    }else {
      [self addChallengeDayInterface];
    }
  }else {
    NIDINFO(@"nil challenge day deal with it!");
  }
}

- (void)cachedIntentsForUser:(NSNotification *)aNotification
{
  //  NSArray *intentsForUser = [[DTCache sharedCache] intentsForUser:[PFUser currentUser]];
  //  NIDINFO(@"the first (and only) intent: %@",[intentsForUser firstObject]);
  //  [DTCommonRequests activeIntent:[intentsForUser firstObject]];
  //  NIDINFO(@"the active intent ID: %@",[[[PFUser currentUser] objectForKey:kDTActiveIntent] objectId]);
  [self addChallengeDayInterface];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:DTIntentDidCacheIntentForUserNotification
                                                object:nil];
}

#pragma mark - DTNavigationBar Delegate Methods

- (void)userDidTapUserProfileButton:(UIButton *)button user:(PFUser *)user
{
  ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUser:[PFUser currentUser]];
  [self presentViewController:profileVC animated:YES completion:NULL];
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
