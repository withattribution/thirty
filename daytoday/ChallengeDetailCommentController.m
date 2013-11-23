//
//  ChallengeDetailCommentController.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDetailCommentController.h"
#import "DTSocialDashBoard.h"
#import "CommentInputView.h"
#import "CommentUtilityView.h"
#import "FDTakeController.h"

#import "UIImage+Resizing.h"
#import "UIColor+SR.h"


@interface ChallengeDetailCommentController ()
//{
//  NSLayoutConstraint * _inputTopConstraint;
//}

@property (nonatomic,strong) DTSocialDashBoard *socialDashBoard;

@property (nonatomic,strong) CommentInputView *commentInput;
@property (nonatomic,strong) CommentUtilityView *commentUtility;

@property (nonatomic,strong) FDTakeController *takeController;

@property (nonatomic,strong) PFFile *commentImageFile;
@property (nonatomic,strong) PFFile *commentThumbnailFile;
@property (nonatomic,assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic,assign) UIBackgroundTaskIdentifier imagePostBackgroundTaskId;

@property (nonatomic,strong) NSString *challengeDayId;

@property (nonatomic,assign) BOOL isTakingPhoto;
@property (nonatomic,assign) BOOL isEnteringComment;
@property (nonatomic,assign) BOOL shouldLayoutCommentInterface;

@end

@implementation ChallengeDetailCommentController

- (void)dealloc
{
  [self removeKeyBoardNotifications];
}

- (id)initWithChallengeDayID:(NSString *)dayId
{
    self = [super init];
    if (self) {
      _challengeDayId = dayId;

//      self.parseClassName = kDTChallengeDayClassKey;
      
      self.isTakingPhoto = NO;
      self.shouldLayoutCommentInterface = NO;
      self.isEnteringComment = NO;
      
      [self.view setBackgroundColor:[UIColor lightGrayColor]];
      
//      NIDINFO(@"the view type: %@",[self.view class]);
      
//      _socialDashBoard = [[DTSocialDashBoard alloc] init];
//      [_socialDashBoard setDelegate:self];
//      [_socialDashBoard setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 40.f)];
      
//      [self.tableView setTableHeaderView:self.socialDashBoard];
      
//      _commentUtility = [[CommentUtilityView alloc] init];
//      [_commentUtility setDelegate:self];
//      [self.tableView addSubview:self.socialDashBoard];
      
//      NIDINFO(@"super view: comment utility: %@",self.commentUtility.superview);
      
//      [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[commentUtility]"
//                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                             metrics:nil
//                                                                               views:@{@"commentUtility":_commentUtility}]];
//      
//      [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentUtility(40)]"
//                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                             metrics:nil
//                                                                               views:@{@"commentUtility":_commentUtility}]];
      
      
//      [self.tableView layoutIfNeeded];
      
//      NIDINFO(@"the superview: %@",self.socialDashBoard.superview);
      
      
//      [self.tableView setFrame:CGRectMake(0.,
//                                         40.f,//_socialDashBoard.frame.origin.y + _socialDashBoard.frame.size.height,
//                                         self.view.frame.size.width,
//                                         240.f - 40.f)];
//      [self addKeyBoardNotifications];
    }
    return self;
}

#pragma mark - Table View Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellID = @"CommentCell";

  // Try to dequeue a cell and create one if necessary
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    cell.cellInsetWidth = kPAPCellInsetWidth;
//    cell.delegate = self;
    cell.backgroundColor = [UIColor randomColor];
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//  if (self.intents && [self.intents count] > 0)
//    return [self.intents count];
//  else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//  if([((Intent *)[self.intents objectAtIndex:section]) daysLeft] > 0)
//    return 3;
//  else
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.f;
}

#pragma mark - PFQueryTableViewController

//- (PFQuery *)queryForTable {
//  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
////  [query whereKey:kDTActivityTypeComment equalTo:kDTActivityTypeKey];
//  
//  [query includeKey:kDTActivityClassKey];
////  [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
////  [query orderByAscending:@"createdAt"];
////  
//  [query setCachePolicy:kPFCachePolicyNetworkOnly];
//  
//  // If no objects are loaded in memory, we look to the cache first to fill the table
//  // and then subsequently do a query against the network.
//  //
//  // If there is no network connection, we will hit the cache first.
////  if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
////    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
////  }
//  
//  return query;
//}

//- (void)objectsDidLoad:(NSError *)error
//{
//  [super objectsDidLoad:error];
//  NIDINFO(@"object count: %d",[self.objects count]);
//  
//  id d = [self.objects firstObject];
//  
//  for (NSString *k in [d allKeys]) {
//    NIDINFO(@"the key: %@ and the object: %@",k,[d objectForKey:k]);
//  }
//}
//  if (NSClassFromString(@"UIRefreshControl")) {
//    [self.refreshControl endRefreshing];
//  }
//  
//  [self.headerView reloadLikeBar];
//  [self loadLikers];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
//{
//  static NSString *cellID = @"CommentCell";
//  
//  // Try to dequeue a cell and create one if necessary
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
////    cell.cellInsetWidth = kPAPCellInsetWidth;
////    cell.delegate = self;
//    cell.backgroundColor = [UIColor randomColor];
//  }
//  
////  [cell setUser:[object objectForKey:kPAPActivityFromUserKey]];
////  [cell setContentText:[object objectForKey:kPAPActivityContentKey]];
////  [cell setDate:[object createdAt]];
//  
//  return cell;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//  static NSString *CellIdentifier = @"NextPage";
//  
//  PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//  
//  if (cell == nil) {
//    cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    cell.cellInsetWidth = kPAPCellInsetWidth;
//    cell.hideSeparatorTop = YES;
//  }
//  
//  return cell;
//}

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

#pragma mark - Comment Utility Delegate Methods

- (void)didCancelCommentAddition
{
  NSLog(@"cancelling comments and shit");
//  if ([_delegate respondsToSelector:@selector(resetCommentController)])
//    [_delegate resetCommentController];
  
  [self.commentInput shouldResignFirstResponder];
  [self cleanUpCommentSubmissionInterface];
  [self.socialDashBoard resetCommentDisplayState];
  self.isEnteringComment = NO;
}

//delete orphaned file on parse backend
//curl -X DELETE \
//-H "X-Parse-Application-Id: <YOUR_APPLICATION_ID>" \
//-H "X-Parse-Master-Key: <YOUR_MASTER_KEY>" \
//https://api.parse.com/1/files/<FILE_NAME>

#pragma mark - Comment Input Delegate Methods

- (void)willHandleAttemptToAddComment:(NSString *)commentText
{
  NIDINFO(@"handle comment: %@",commentText);
  
  NSString *trimmedComment = [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  //build and send the photo object then the activity object because it depends on the activity object
  PFObject *comment = [PFObject objectWithClassName:kDTActivityClassKey];
  comment[kDTActivityTypeKey] = kDTActivityTypeComment;
  comment[kDTActivityChallengeDayKey] = [PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:_challengeDayId];
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

#pragma mark - DTSocial DashBoard Delegate Methods

//- (void)didSelectComments
//{
//  self.isTakingPhoto = NO;
//  self.shouldLayoutCommentInterface = YES;
//  self.isEnteringComment = YES;
//
//  if ([_delegate respondsToSelector:@selector(willHandleCommentAddition)])
//    [_delegate willHandleCommentAddition];
//
//  
//  if(!self.commentUtility){
//    _commentUtility = [[CommentUtilityView alloc] init];
//    [_commentUtility setDelegate:self];
//    [self.tableView setTableHeaderView:self.commentUtility];
//    NIDINFO(@"super view: comment utility: %@",self.commentUtility.superview);
//
//  }
//
//  
//  if(!self.commentInput){
//    _commentInput = [[CommentInputView alloc] init];
//    [_commentInput setDelegate:self];
//    [self.tableView setTableHeaderView:self.commentInput];
//    [self.tableView.tableFooterView bringSubviewToFront:self.commentInput];
//    NIDINFO(@"super view: commentinput: %@",self.commentInput.superview);
//    
//  }
//
//  [self.commentInput shouldBeFirstResponder];
//}

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
  
  [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[commentInput]|"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentInput":_commentInput}]];
  
  [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentInput(36)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentInput":_commentInput}]];
  
  [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[commentUtility]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentUtility":_commentUtility}]];
  
  [self.tableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentUtility(40)]"
                                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                                    metrics:metrics
                                                                      views:@{@"commentUtility":_commentUtility}]];

  [self.tableView layoutIfNeeded];
}

- (void)presentCommentSubmissionInterfaceWith:(NSNumber *)duration andAnimationCurve:(NSNumber *)curve andKeyBoardFrame:(CGRect)kBoardFrame
{
  CGFloat tableOriginHeight = self.tableView.frame.origin.y;
  
//  [self.view removeConstraint:_inputTopConstraint];
//  
//  _inputTopConstraint = [NSLayoutConstraint constraintWithItem:self.commentInput
//                                                     attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeTop
//                                                    multiplier:1.f
//                                                      constant:kBoardFrame.size.height-2.f];
//  
//  [self.view addConstraint:_inputTopConstraint];
  
  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.tableView layoutIfNeeded];
                     
                     [self.tableView setFrame: (self.isEnteringComment) ?
                      CGRectMake(0.,
                                 tableOriginHeight,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height - kBoardFrame.size.height - 40.f - 50.f) :
                      CGRectMake(0.,
                                 40.f,
                                 self.view.frame.size.width,
                                 240.f - 40.f)];

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
//  CGRect boardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  
//  [self.view removeConstraint:_inputTopConstraint];
//  
//  _inputTopConstraint = [NSLayoutConstraint constraintWithItem:self.commentInput
//                                                     attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeTop
//                                                    multiplier:1.f
//                                                      constant:480.f];
//  
//  [self.view addConstraint:_inputTopConstraint];
  
  CGFloat tableOriginHeight = self.tableView.frame.origin.y;

  [UIView animateWithDuration:[duration doubleValue]
                        delay:0.f
                      options:([curve intValue] | UIViewAnimationOptionBeginFromCurrentState)
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                     [self.tableView setFrame: (self.isEnteringComment) ?
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


@end
