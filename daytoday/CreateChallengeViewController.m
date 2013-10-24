//
//  CreateChallengeViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CreateChallengeViewController.h"
#import "DTSelectionSheet.h"

#import "ChallengeName.h"
#import "ChallengeDescription.h"

#import <UIColor+SR.h>

@interface CreateChallengeViewController () {

}

@property (nonatomic, weak) UIViewController *currentChildViewController;

@end

@implementation CreateChallengeViewController

CGFloat static TRANSITION_VELOCITY = 0.428571f;
CGFloat static TRANSITION_DURATION = 0.559821f;
CGFloat static TRANSITION_SCALE = 0.767857f;
CGFloat static TRANSITION_ALPHA = 0.241071f;
CGFloat static WIDTH_FACTOR = 0.85f;
CGFloat static NAME_VIEW_HEIGHT = 44.f;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Add an initial contained viewController
  UIViewController *viewController = [self nextViewController];
  
  // Contain the view controller
  [self addChildViewController:viewController];
  [self.view addSubview:viewController.view];
  
  [viewController didMoveToParentViewController:self];
  self.currentChildViewController = viewController;
  
  self.title = NSLocalizedString(@"Create Challenge", @"create challenge (title)");
  
  UIButton *startCreationFlow = [UIButton buttonWithType:UIButtonTypeCustom];
  [startCreationFlow.titleLabel setTextColor:[UIColor colorWithWhite:0.8f alpha:1.f]];
  [startCreationFlow setBackgroundColor:[UIColor lightGrayColor]];
  
  [startCreationFlow setTitle:@"Create Challenge" forState:UIControlStateNormal];
  [startCreationFlow addTarget:self
                        action:@selector(transitionToChallengeFLow)
              forControlEvents:UIControlEventTouchUpInside];
  
  startCreationFlow.translatesAutoresizingMaskIntoConstraints = NO;
  [viewController.view addSubview:startCreationFlow];
  
  [viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startCreationFlow]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"startCreationFlow":startCreationFlow}]];
  
  [viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[startCreationFlow(50)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"startCreationFlow":startCreationFlow}]];
  
//  [[DTSelectionSheet selectionSheetWithTitle:@"select duration"] performSelector:@selector(showInView:) withObject:self.view afterDelay:0.0];
}

- (void) transitionToChallengeFLow
{
  CGFloat width = CGRectGetWidth(self.view.bounds);
  CGFloat height = CGRectGetHeight(self.view.bounds);
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformMakeTranslation(width, 0);
  
  UIViewController *nextViewController = [self nextViewController];
  
  ChallengeName *nameFieldView = [[ChallengeName alloc] initWithFrame:CGRectZero];
  [nameFieldView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [nextViewController.view addSubview:nameFieldView];
  
  NSDictionary *metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR),@"nameViewHeight":@(NAME_VIEW_HEIGHT)};
  
  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameFieldView(fieldWidth)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameFieldView":nameFieldView}]];
  
  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameFieldView(nameViewHeight)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameFieldView":nameFieldView}]];
  
  [nameFieldView namingDidComplete:^{
    [self shouldEnterDescription];
  }];
  
  // Containment
  [self addChildViewController:nextViewController];
  [self.currentChildViewController willMoveToParentViewController:nil];
  
  nextViewController.view.transform = transform;
  
  [self transitionFromViewController:self.currentChildViewController
                    toViewController:nextViewController
                            duration:TRANSITION_DURATION
                             options:0
                          animations:^{
                            self.currentChildViewController.view.alpha = TRANSITION_ALPHA;
                            CGAffineTransform transform = CGAffineTransformMakeTranslation(-nextViewController.view.transform.tx * TRANSITION_VELOCITY,
                                                                                           -nextViewController.view.transform.ty * TRANSITION_VELOCITY);
                            transform = CGAffineTransformRotate(transform, acosf(nextViewController.view.transform.a));
                            self.currentChildViewController.view.transform = CGAffineTransformScale(transform, TRANSITION_SCALE, TRANSITION_SCALE);
                            nextViewController.view.transform = CGAffineTransformIdentity;
                          } completion:^(BOOL finished) {
                            [nextViewController didMoveToParentViewController:self];
                            [self.currentChildViewController removeFromParentViewController];
                            self.currentChildViewController = nextViewController;
                            [nameFieldView shouldBeFirstResponder];
                          }];
}

- (UIViewController *)nextViewController
{
  UIViewController *viewController = [UIViewController new];
  viewController.view.frame = self.view.bounds;
  viewController.view.backgroundColor = [UIColor randomColor];
  
  return viewController;
}

- (void)shouldEnterDescription
{
  NSLog(@"THIS COMPLETED AND YOU MAYBE UNDERSTAND BLOX");
  ChallengeDescription *cd = [[ChallengeDescription alloc] init];
  [cd setBackgroundColor:[UIColor redColor]];
  [cd setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.currentChildViewController.view addSubview:cd];

  NSDictionary *cd_metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR)};

  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cd(fieldWidth)]"
                                                                              options:0
                                                                              metrics:cd_metrics
                                                                                views:@{@"cd":cd}]];

  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cd(150)]"
                                                                              options:0
                                                                              metrics:cd_metrics
                                                                                views:@{@"cd":cd}]];
//  [UIView animateWithDuration:0.4F
//                   animations:^{
//                     [self.currentChildViewController.view layoutIfNeeded];
//                   }
//                   completion:^(BOOL finished) {
//                     if (finished) {
//                       [cd shouldBeFirstResponder];
//                     }
//                   }];
  [cd shouldBeFirstResponder];

}

//- (CGAffineTransform)startingTransformForViewControllerTransition:(ViewControllerTransition)transition
//{
//  CGFloat width = CGRectGetWidth(self.view.bounds);
//  CGFloat height = CGRectGetHeight(self.view.bounds);
//  CGAffineTransform transform = CGAffineTransformIdentity;
//  
//  switch (transition)
//  {
//    case ViewControllerTransitionSlideFromTop:
//      transform = CGAffineTransformMakeTranslation(0, -height);
//      break;
//    case ViewControllerTransitionSlideFromLeft:
//      transform = CGAffineTransformMakeTranslation(-width, 0);
//      break;
//    case ViewControllerTransitionSlideFromRight:
//      transform = CGAffineTransformMakeTranslation(width, 0);
//      break;
//    case ViewControllerTransitionSlideFromBottom:
//      transform = CGAffineTransformMakeTranslation(0, height);
//      break;
//    case ViewControllerTransitionRotateFromRight:
//      transform = CGAffineTransformMakeTranslation(width, 0);
//      transform = CGAffineTransformRotate(transform, M_PI);
//      break;
//    default:
//      break;
//  }
//  
//  return transform;
//}

@end
