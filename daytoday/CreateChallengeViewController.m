//
//  CreateChallengeViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CreateChallengeViewController.h"
#import "DTSelectionSheet.h"
#import <UIColor+SR.h>

@interface CreateChallengeViewController ()

@property (nonatomic, weak) UIViewController *currentChildViewController;

@end

@implementation CreateChallengeViewController

CGFloat static TRANSITION_VELOCITY = 0.428571f;
CGFloat static TRANSITION_DURATION = 0.559821f;
CGFloat static TRANSITION_SCALE = 0.767857f;
CGFloat static TRANSITION_ALPHA = 0.241071f;

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
  [self.view addSubview:startCreationFlow];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startCreationFlow]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"startCreationFlow":startCreationFlow}]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[startCreationFlow(50)]"
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
                            CGAffineTransform transform = CGAffineTransformMakeTranslation(-nextViewController.view.transform.tx * TRANSITION_VELOCITY, -nextViewController.view.transform.ty * TRANSITION_VELOCITY);
                            transform = CGAffineTransformRotate(transform, acosf(nextViewController.view.transform.a));
                            self.currentChildViewController.view.transform = CGAffineTransformScale(transform, TRANSITION_SCALE, TRANSITION_SCALE);
                            nextViewController.view.transform = CGAffineTransformIdentity;
                          } completion:^(BOOL finished) {
                            [nextViewController didMoveToParentViewController:self];
                            [self.currentChildViewController removeFromParentViewController];
                            self.currentChildViewController = nextViewController;
  }];
}

- (UIViewController *)nextViewController
{
  UIViewController *viewController = [UIViewController new];
  viewController.view.frame = self.view.bounds;
  viewController.view.backgroundColor = [UIColor randomColor];

  return viewController;
}

@end
