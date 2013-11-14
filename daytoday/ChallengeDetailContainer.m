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
@property (nonatomic, assign) CGPoint preVelocity;

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
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCommentController:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_commentController.view addGestureRecognizer:panRecognizer];
  }
  
  return self;
}

- (void)moveCommentController:(UIGestureRecognizer *)sender
{
  [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
  
  CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
  CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
  
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//    UIView *childView = nil;
//    
//    if(velocity.x > 0) {
//      if (!_showingRightPanel) {
//        childView = [self getLeftView];
//      }
//    } else {
//      if (!_showingLeftPanel) {
//        childView = [self getRightView];
//      }
//
//    }
    // Make sure the view you're working with is front and center.
//    [self.view sendSubviewToBack:childView];
    [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
  }
  
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
    
    if(velocity.y > 0) {
      // NSLog(@"gesture went right");
    } else {
      // NSLog(@"gesture went left");
    }
    
    if (_commentsAreFullScreen) {
      [self moveControllerToOriginalPosition];
    } else {
      [self moveControllerToTop];
      
//      if (_showingLeftPanel) {
//        [self movePanelRight];
//      }  else if (_showingRightPanel) {
//        [self movePanelLeft];
//      }
    }
  }
  
  if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
    if(velocity.y > 0) {
       NSLog(@"gesture went down");
    } else {
       NSLog(@"gesture went up");
    }
    
    // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
//    _showPanel = abs([sender view].center.x - _verficationController.view.frame.size.width/2) > _verficationController.view.frame.size.width/2;
    
    // Allow dragging only in y-coordinates by only updating the x-coordinate with translation position.
    [sender view].center = CGPointMake([sender view].center.x, [sender view].center.y + translatedPoint.y);
    [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
    
    // If you needed to check for a change in direction, you could use this code to do so.
    if(velocity.y*_preVelocity.y + velocity.y*_preVelocity.y > 0) {
      // NSLog(@"same direction");
    } else {
      // NSLog(@"opposite direction");
    }
    
    _preVelocity = velocity;
  }
}


- (void)moveControllerToTop
{
  [UIView animateWithDuration:.42f
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState
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
	[UIView animateWithDuration:.42f
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState
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
