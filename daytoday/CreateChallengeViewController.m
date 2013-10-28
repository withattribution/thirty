//
//  CreateChallengeViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CreateChallengeViewController.h"
#import "DTSelectionSheet.h"
#import "VerificationType.h"

#import "ChallengeName.h"
#import "ChallengeDescription.h"

#import <UIColor+SR.h>
#import "DTDotElement.h"

@interface CreateChallengeViewController () {
  ChallengeName *nameView;
  ChallengeDescription *descriptionView;
  UIImageView *categoryImage;
}

- (void)transitionToChallengeFLow;
- (void)shouldEnterDescription;
- (void)selectCategory;

@property (nonatomic, weak) UIViewController *currentChildViewController;

@end

@implementation CreateChallengeViewController

#define PRESET_DURATION 30
#define PRESET_VERIFICATION 0
#define PRESET_REPETITION 1

CGFloat static TRANSITION_VELOCITY = 0.428571f; //Used for transition to child view controllers
CGFloat static TRANSITION_DURATION = 0.559821f; // --
CGFloat static TRANSITION_SCALE = 0.767857f;    // --
CGFloat static TRANSITION_ALPHA = 0.241071f;    //Used for transition to child view controllers

CGFloat static WIDTH_FACTOR = 0.85f;            //Common width for all text input views
CGFloat static NAME_VIEW_HEIGHT = 44.f;         //Hardcoded nameview height
CGFloat static INPUT_VIEW_PADDING = 5.f;        //Padding between text containing views

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
}

- (void)transitionToChallengeFLow
{
  CGFloat width = CGRectGetWidth(self.view.bounds);
  CGFloat height = CGRectGetHeight(self.view.bounds);

  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformMakeTranslation(width, 0);
  
  UIViewController *nextViewController = [self nextViewController];
  
  nameView = [[ChallengeName alloc] initWithFrame:CGRectZero];
  [nextViewController.view addSubview:nameView];
  
  NSDictionary *metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR),@"nameViewHeight":@(NAME_VIEW_HEIGHT)};
  
  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(fieldWidth)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameView":nameView}]];
  
  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameView(nameViewHeight)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameView":nameView}]];
  [nameView namingDidComplete:^{
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
                            [nameView shouldBeFirstResponder];
                          }];
}

- (UIViewController *)nextViewController
{
  UIViewController *viewController = [UIViewController new];
  viewController.view.frame = self.view.bounds;
  viewController.view.backgroundColor = [UIColor randomColor];

  return viewController;
}

#pragma mark Challenge Creation Flow Methods

- (void)shouldEnterDescription
{
  descriptionView = [[ChallengeDescription alloc] init];
  [self.currentChildViewController.view addSubview:descriptionView];

  NSDictionary *descriptionView_metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR)};

  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionView(fieldWidth)]"
                                                                              options:0
                                                                              metrics:descriptionView_metrics
                                                                                views:@{@"descriptionView":descriptionView}]];

  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionView(110)]"
                                                                              options:0
                                                                              metrics:descriptionView_metrics
                                                                                views:@{@"descriptionView":descriptionView}]];

  [self.currentChildViewController.view layoutIfNeeded];

  [descriptionView animateIntoViewForHeight:(nameView.frame.origin.y + nameView.frame.size.height + INPUT_VIEW_PADDING)];

  [descriptionView descriptionDidComplete:^{
    [self selectCategory];
  }];
}

- (void)selectCategory
{
  DTSelectionSheet *selectSheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetCategory];
  [selectSheet showInView:self.currentChildViewController.view];

  __block id theSelected = nil;

  [selectSheet didCompleteWithSelectedObject:^(id obj){
    theSelected = obj;
    NSLog(@"the selected :%@",theSelected);
    if (obj && [obj isKindOfClass:[UIImageView class]]) {
      [self placeSelectedCategoryImage:obj];
    }
    
  }];
}

//TODO replace with a uiimageview with an image
- (void)placeSelectedCategoryImage:(UIImageView *)catImage
{
  if (categoryImage) {
    //if another image has already been set update the displayed version
    [categoryImage removeFromSuperview];
  }
  
  categoryImage = catImage;
  
  [categoryImage setAlpha:0.2];
  [categoryImage setUserInteractionEnabled:NO];
  [categoryImage setTranslatesAutoresizingMaskIntoConstraints:NO];
  
  [self.currentChildViewController.view insertSubview:categoryImage atIndex:0];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[categoryImage]|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:@{@"categoryImage":categoryImage}]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[categoryImage]"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:@{@"categoryImage":categoryImage}]];
  [self.currentChildViewController.view layoutIfNeeded];

  [UIView animateWithDuration:0.6f
                   animations:^{
                     [categoryImage setAlpha:1.f];
                   }
                   completion:^(BOOL finished) {
                     [self placeOptionalChallengeCreationSelections];
                   }];
}

- (void)placeOptionalChallengeCreationSelections
{
  CGSize buttonSize = CGSizeMake(80., 80.);
  CGFloat buttonContainerWidth = descriptionView.frame.size.width;
  CGFloat buttonSpacing = (buttonContainerWidth - (3*buttonSize.width)) /2.f;
  CGFloat buttonYOffset = descriptionView.frame.origin.y + descriptionView.frame.size.height + 10.f;
  
  DTDotElement *durationDot = [[DTDotElement alloc] initWithFrame:CGRectMake(descriptionView.frame.origin.x,
                                                                             buttonYOffset,
                                                                             buttonSize.width,
                                                                             buttonSize.height)
                                                    andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                        andNumber:[NSNumber numberWithInt:PRESET_DURATION]];
  UIButton *durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [durationButton setFrame:durationDot.bounds];
//  [selectionButton setTag:i];
  [durationButton setBackgroundColor:[UIColor clearColor]];
  [durationButton addTarget:self action:@selector(selectDuration:) forControlEvents:UIControlEventTouchUpInside];
  
  [durationDot addSubview:durationButton];
  
  [self.currentChildViewController.view addSubview:durationDot];
  
  DTDotElement *verifyDot = [[DTDotElement alloc] initWithFrame:CGRectMake(durationDot.frame.origin.x + durationDot.frame.size.width + buttonSpacing,
                                                                           buttonYOffset,
                                                                           buttonSize.width,
                                                                           buttonSize.height)
                                                  andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                       andImage:[[VerificationType verficationWithType:DTVerificationTickMark] displayImage]];
  UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [verifyButton setFrame:verifyDot.bounds];
  //  [selectionButton setTag:i];
  [verifyButton setBackgroundColor:[UIColor clearColor]];
  [verifyButton addTarget:self action:@selector(selectVerification:) forControlEvents:UIControlEventTouchUpInside];
  
  [verifyDot addSubview:verifyButton];
  
  [self.currentChildViewController.view addSubview:verifyDot];
  
  DTDotElement *repititionDot = [[DTDotElement alloc] initWithFrame:CGRectMake(verifyDot.frame.origin.x + verifyDot.frame.size.width + buttonSpacing,
                                                                             buttonYOffset,
                                                                             buttonSize.width,
                                                                             buttonSize.height)
                                                    andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                        andNumber:[NSNumber numberWithInt:PRESET_REPETITION]];
  UIButton *repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [repeatButton setFrame:repititionDot.bounds];
  //  [selectionButton setTag:i];
  [repeatButton setBackgroundColor:[UIColor clearColor]];
  [repeatButton addTarget:self action:@selector(selectRepetition:) forControlEvents:UIControlEventTouchUpInside];
  
  [repititionDot addSubview:repeatButton];
  
  [self.currentChildViewController.view addSubview:repititionDot];
  
  NSString *startText = NSLocalizedString(@"START!", @"text for start button");
  
  UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [startButton setTitle:startText forState:UIControlStateNormal];
  [startButton setBackgroundColor:[UIColor randomColor]];
  [startButton addTarget:self action:@selector(attemptChallengeCreation:) forControlEvents:UIControlEventTouchUpInside];
  
  [startButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.currentChildViewController.view addSubview:startButton];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[startButton(startWidth)]"
                                                                                               options:0
                                                                                               metrics:@{@"startWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR)}
                                                                                                 views:@{@"startButton":startButton}]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-startYOffset-[startButton(40)]"
                                                                                               options:0
                                                                                               metrics:@{@"startYOffset":@(self.currentChildViewController.view.frame.size.height*.75)}
                                                                                                 views:@{@"startButton":startButton}]];
  
  [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:startButton
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:startButton.superview
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                  multiplier:1.f
                                                                                    constant:0]];
  
  [self.currentChildViewController.view layoutIfNeeded];
  
  startButton.transform = CGAffineTransformMakeTranslation(0, startButton.bounds.size.height);
  [UIView animateWithDuration:TRANSITION_DURATION
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     startButton.transform = CGAffineTransformMakeTranslation(0, 0);
                   }
                   completion:NULL];
  
}

- (void)selectDuration:(UIButton *)button
{
  DTSelectionSheet *durationSheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetDuration];
  [durationSheet showInView:self.currentChildViewController.view];
  [durationSheet didCompleteWithSelectedObject:^(id obj){
    NSLog(@"this is durationl: %@", obj);
  }];
}

- (void)selectVerification:(UIButton *)button
{
  DTSelectionSheet *verifySheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetVerification];
  [verifySheet showInView:self.currentChildViewController.view];
  [verifySheet didCompleteWithSelectedObject:^(id obj){
    NSLog(@"this is verification: %@", obj);
  }];
}

- (void)selectRepetition:(UIButton *)button
{
  DTSelectionSheet *repititionSheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetRepetition];
  [repititionSheet showInView:self.currentChildViewController.view];
  [repititionSheet didCompleteWithSelectedObject:^(id obj){
    NSLog(@"this is repitition: %@",obj);
  }];
}

- (void)attemptChallengeCreation:(UIButton *)b
{
  //step through challenge data and verify that the minimum necessary data is included
  
  
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
