//
//  ChallengeDetailContainer.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDetailContainer.h"
#import "ChallengeDetailVerificationController.h"
#import "ChallengeDetailCommentController.h"

@interface ChallengeDetailContainer () <UIGestureRecognizerDelegate,ChallengeDetailVerificationControllerDelegate>

@property (nonatomic,strong) ChallengeDetailVerificationController *verficationController;
@property (nonatomic,strong) ChallengeDetailCommentController *commentController;

@property (nonatomic, assign) BOOL commentsAreFullScreen;
@property (nonatomic, assign) NSUInteger panningVelocityYThreshold;
@property (nonatomic, assign) CGFloat commentControllerAnchor;


@end

@implementation ChallengeDetailContainer

- (id)init
{
  self = [super init];
  if(self){
    _verficationController = [[ChallengeDetailVerificationController alloc] init];
    [_verficationController setDelegate:self];
    [self.view addSubview:_verficationController.view];
    [self addChildViewController:_verficationController];
    
    [_verficationController didMoveToParentViewController:self];
    
    
    _commentController = [[ChallengeDetailCommentController alloc] init];
    
    [self.view addSubview:_commentController.view];
    [self addChildViewController:_commentController];
    [_commentController didMoveToParentViewController:self];
    
    [_commentController.view setFrame:CGRectMake(0.f, 240.f, self.view.frame.size.width, self.view.frame.size.height)];
    _commentsAreFullScreen = NO;
    
    self.commentControllerAnchor = _commentController.view.frame.origin.y - 50.f;
    self.panningVelocityYThreshold = 500;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCommentController:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_commentController.view addGestureRecognizer:panRecognizer];
  }
  
  return self;
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
    
//    NSLog(@"vel: %f",currentVelocityY);
    
    if(viewIsPastAnchor || abs(currentVelocityY) > self.panningVelocityYThreshold) {
      
      if(self.commentsAreFullScreen && currentVelocityY < 0){
        [self moveControllerToTop];
      }
      if(self.commentsAreFullScreen && currentVelocityY > 0) {
        [self moveControllerToOriginalPosition];
      }else if(currentVelocityY < 0){
        [self moveControllerToTop];
      }else {
        [self moveControllerToOriginalPosition];
      }
    }else {
      [self moveControllerToOriginalPosition];
    }

  }
  
  if([recognizer state] == UIGestureRecognizerStateChanged) {
    [recognizer view].center = CGPointMake([recognizer view].center.x, [recognizer view].center.y + translatedPoint.y);
    [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
  }
}


- (void)moveControllerToTop
{
  [UIView animateWithDuration:.32f
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState| UIViewAnimationCurveEaseOut
                   animations:^{
                     _commentController.view.frame = CGRectMake(0.f,
                                                                0.f,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       _commentsAreFullScreen = YES;
                     }
                   }];
}

-(void)moveControllerToOriginalPosition {
	[UIView animateWithDuration:.32f
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut
                   animations:^{
                     _commentController.view.frame = CGRectMake(0.f,
                                                                240.f,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height);
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                       _commentsAreFullScreen = NO;
                     }
                   }];
}

 - (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController.navigationBar setHidden:YES];
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

@end
