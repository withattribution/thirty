//
//  CreateChallengeViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "CreateChallengeViewController.h"

#import "DTSelectionSheet.h"
#import "Verification+UImage.h"
#import "Category+UIImage.h"

#import "ChallengeName.h"
#import "ChallengeDescription.h"

#import <UIColor+SR.h>
#import "DTDotElement.h"

@interface CreateChallengeViewController () {
  ChallengeName *nameView;
  ChallengeDescription *descriptionView;
  
  UIButton *categoryEditButton;
  UIImageView *categoryImage;

  DTDotElement *durationDot;
  DTDotElement *verificationDot;
  DTDotElement *frequencyDot;
  
  NSNumber *duration;
  NSNumber *verificationType;
  NSNumber *freqCount;
  NSNumber *category;
}

- (void)transitionToChallengeFLow;
- (void)shouldEnterDescription;
- (void)selectCategory;
- (void)setChallengeCreationDefaultValues;

@property (nonatomic,retain) NSMutableDictionary *creationDictionary;
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
CGFloat static NAME_VIEW_HEIGHT = 35.f;         //Hardcoded nameview height
CGFloat static INPUT_VIEW_PADDING = 5.f;        //Padding between text containing views

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _creationDictionary = [[NSMutableDictionary alloc] init];
  
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
  [self setChallengeCreationDefaultValues];
}

- (void)setChallengeCreationDefaultValues
{
  duration = [NSNumber numberWithInt:30];
  verificationType = [NSNumber numberWithInt:DTVerificationTickMark];
  freqCount = [NSNumber numberWithInt:1];
  
  [self.creationDictionary setObject:[NSNull null] forKey:@"name"];
  [self.creationDictionary setObject:[NSNull null] forKey:@"description"];
  [self.creationDictionary setObject:[NSNull null] forKey:@"category"];
  [self.creationDictionary setObject:[duration stringValue] forKey:@"duration"];
  [self.creationDictionary setObject:[verificationType stringValue] forKey:@"verification"];
  [self.creationDictionary setObject:[freqCount stringValue] forKey:@"frequency"];
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
  //observing the isEditing state of the ChallengeName object's uitextfield rather
  //than setting up nsnotifications for just one ui element.
  //when the uitextfield is the first responder -- all other text containing elements
  //should be removed or made less distracting to the user.
  if ([keyPath isEqualToString:@"isEditing"]) {
    NSLog(@"the changed object %@",[change objectForKey:NSKeyValueChangeNewKey]);
    [descriptionView setAlpha:([[change objectForKey:NSKeyValueChangeNewKey] integerValue])];
  }
  
  [self.creationDictionary  setObject:[change objectForKey:NSKeyValueChangeNewKey] forKey:keyPath];
//  for (NSString *thekey in self.creationDictionary) {
//    NSLog(@"the keys :%@ and object: %@",thekey, [self.creationDictionary objectForKey:thekey]);
//  }
}

- (void)transitionToChallengeFLow
{
  CGFloat width = CGRectGetWidth(self.view.bounds);
//  CGFloat height = CGRectGetHeight(self.view.bounds);

  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformMakeTranslation(width, 0);

  UIViewController *nextViewController = [self nextViewController];

  nameView = [[ChallengeName alloc] init];
  [nextViewController.view addSubview:nameView];

  [nameView addObserver:self
             forKeyPath:@"name"
                options:NSKeyValueObservingOptionNew
                context:NULL];

  [nameView addObserver:self
             forKeyPath:@"isEditing"
                options:NSKeyValueObservingOptionNew
                context:NULL];

  NSDictionary *metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR),@"nameViewHeight":@(NAME_VIEW_HEIGHT)};

  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameView(fieldWidth)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameView":nameView}]];

  [nextViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameView(nameViewHeight)]"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:@{@"nameView":nameView}]];
  
  [nextViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:nameView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nextViewController.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.f
                                                                       constant:0]];
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

  [nameView addObserver:viewController forKeyPath:@"challengeName" options:NSKeyValueObservingOptionNew context:NULL];

  return viewController;
}

#pragma mark Challenge Creation Flow Methods

- (void)shouldEnterDescription
{
  if (!descriptionView) {
    descriptionView = [[ChallengeDescription alloc] init];
    [self.currentChildViewController.view addSubview:descriptionView];

    [descriptionView addObserver:self
               forKeyPath:@"description"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];

    NSDictionary *descriptionView_metrics = @{@"fieldWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR)};

    [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionView(fieldWidth)]"
                                                                                options:0
                                                                                metrics:descriptionView_metrics
                                                                                  views:@{@"descriptionView":descriptionView}]];
    
    [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionView(110)]"
                                                                                                 options:0
                                                                                                 metrics:descriptionView_metrics
                                                                                                   views:@{@"descriptionView":descriptionView,@"nameView":nameView}]];
    
    [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:descriptionView
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.currentChildViewController.view
                                                                                     attribute:NSLayoutAttributeCenterX
                                                                                    multiplier:1.f
                                                                                      constant:0]];
    
    [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:descriptionView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:nameView
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1.f
                                                                                      constant:INPUT_VIEW_PADDING]];
  }
  
  [self.currentChildViewController.view layoutIfNeeded];
  
  [descriptionView animateIntoView];

  [descriptionView descriptionDidComplete:^{
    if ([[self.creationDictionary objectForKey:@"category"] isEqual:[NSNull null]]) {
      [self selectCategory];
    }
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
      #warning this is missing an actual category type -- currently using the selected tag -- gonna break
      category = [NSNumber numberWithInt:((UIImageView*)obj).tag];
      [self.creationDictionary setObject:[category stringValue] forKey:@"category"];
      [self placeSelectedCategoryImage:obj];

      NSString *catTitle = [Category_UIImage stringForType:((UIImageView*)obj).tag];

      if (!categoryEditButton) {
        categoryEditButton = [UIButton buttonWithType:UIButtonTypeCustom];        
        [categoryEditButton.titleLabel setTextColor:[UIColor colorWithWhite:1.f alpha:1.f]];
        [categoryEditButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];

        [categoryEditButton setBackgroundColor:[UIColor colorWithWhite:.7f alpha:.6f]];
        [categoryEditButton addTarget:self action:@selector(selectCategory) forControlEvents:UIControlEventTouchUpInside];
        [categoryEditButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.currentChildViewController.view addSubview:categoryEditButton];
      }

        [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[categoryEditButton]"
                                                                                                     options:0
                                                                                                     metrics:@{@"editWidth":@([[UIScreen mainScreen] bounds].size.width*.5)}
                                                                                                       views:@{@"categoryEditButton":categoryEditButton}]];
        
        [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-offset-[categoryEditButton]"
                                                                                                     options:0
                                                                                                     metrics:@{@"offset":@(descriptionView.frame.origin.y+descriptionView.frame.size.height+6.f)}
                                                                                                       views:@{@"categoryEditButton":categoryEditButton}]];

        [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryEditButton
                                                                                         attribute:NSLayoutAttributeCenterX
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:categoryEditButton.superview
                                                                                         attribute:NSLayoutAttributeCenterX
                                                                                        multiplier:1.f
                                                                                          constant:0]];
      
      [categoryEditButton setTitle:[NSString stringWithFormat:@" %@ + ",catTitle] forState:UIControlStateNormal];
      [self.currentChildViewController.view layoutIfNeeded];
    }
  }];
}

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
                     if (!durationDot || !verificationDot || !frequencyDot) {
                       [self placeDefaultChallengeCreationSelections];
                     }
                   }];
}

- (void)placeDefaultChallengeCreationSelections
{
  CGSize buttonSize = CGSizeMake(80., 80.);
  CGFloat buttonContainerWidth = descriptionView.frame.size.width;
  CGFloat buttonSpacing = (buttonContainerWidth - (3*buttonSize.width)) /2.f;
  CGFloat buttonYOffset = categoryEditButton.frame.origin.y + categoryEditButton.frame.size.height + 5.f;
  
  NSLog(@"buttonYOffset: %f",descriptionView.frame.size.height);
  
  durationDot = [[DTDotElement alloc] initWithFrame:CGRectMake(descriptionView.frame.origin.x,
                                                                             buttonYOffset,
                                                                             buttonSize.width,
                                                                             buttonSize.height)
                                                    andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                        andNumber:[NSNumber numberWithInt:PRESET_DURATION]];
  UIButton *durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [durationButton setFrame:durationDot.bounds];
  [durationButton setBackgroundColor:[UIColor clearColor]];
  [durationButton addTarget:self action:@selector(selectDuration:) forControlEvents:UIControlEventTouchUpInside];

  [durationDot addSubview:durationButton];

  [self.currentChildViewController.view addSubview:durationDot];

  verificationDot = [[DTDotElement alloc] initWithFrame:CGRectMake(durationDot.frame.origin.x + durationDot.frame.size.width + buttonSpacing,
                                                                           buttonYOffset,
                                                                           buttonSize.width,
                                                                           buttonSize.height)
                                                  andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                       andImage:[Verification imageForType:DTVerificationTickMark]];

  UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [verifyButton setFrame:verificationDot.bounds];
  [verifyButton setBackgroundColor:[UIColor clearColor]];
  [verifyButton addTarget:self action:@selector(selectVerification:) forControlEvents:UIControlEventTouchUpInside];
  
  [verificationDot addSubview:verifyButton];
  
  [self.currentChildViewController.view addSubview:verificationDot];
  
  frequencyDot = [[DTDotElement alloc] initWithFrame:CGRectMake(verificationDot.frame.origin.x + verificationDot.frame.size.width + buttonSpacing,
                                                                             buttonYOffset,
                                                                             buttonSize.width,
                                                                             buttonSize.height)
                                                    andColorGroup:[DTDotColorGroup summaryDayColorGroup]
                                                        andNumber:[NSNumber numberWithInt:PRESET_REPETITION]];
  UIButton *repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [repeatButton setFrame:frequencyDot.bounds];
  [repeatButton setBackgroundColor:[UIColor clearColor]];
  [repeatButton addTarget:self action:@selector(selectFrequency:) forControlEvents:UIControlEventTouchUpInside];
  
  [frequencyDot addSubview:repeatButton];
  
  [self.currentChildViewController.view addSubview:frequencyDot];
  
  NSString *startText = NSLocalizedString(@"START!", @"text for start button");
  
  UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [startButton setTitle:startText forState:UIControlStateNormal];
  [startButton setBackgroundColor:[UIColor randomColor]];
  [startButton addTarget:self action:@selector(attemptChallengeCreation:) forControlEvents:UIControlEventTouchUpInside];
  
  [startButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.currentChildViewController.view addSubview:startButton];
  
  NSString *durationText = NSLocalizedString(@"DURATION", @"duration label");

  UILabel *durationLabel = [[UILabel alloc] init];
  durationLabel.textColor = [UIColor colorWithWhite:.9 alpha:1.f];
  durationLabel.backgroundColor = [UIColor clearColor];
  durationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
  durationLabel.text = durationText;
  durationLabel.numberOfLines = 1;
  durationLabel.textAlignment = NSTextAlignmentCenter;
  [durationLabel sizeToFit];
  durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.currentChildViewController.view addSubview:durationLabel];
  
  NSString *verificationText = NSLocalizedString(@"VERIFICATION", @"verification label");
  
  UILabel *verificationLabel = [[UILabel alloc] init];
  verificationLabel.textColor = [UIColor colorWithWhite:.9 alpha:1.f];
  verificationLabel.backgroundColor = [UIColor clearColor];
  verificationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
  verificationLabel.text = verificationText;
  verificationLabel.numberOfLines = 1;
  verificationLabel.textAlignment = NSTextAlignmentCenter;
  [verificationLabel sizeToFit];
  verificationLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.currentChildViewController.view addSubview:verificationLabel];
  
  NSString *freqText = NSLocalizedString(@"FREQUENCY", @"frequency label");
  
  UILabel *freqLabel = [[UILabel alloc] init];
  freqLabel.textColor = [UIColor colorWithWhite:.9 alpha:1.f];
  freqLabel.backgroundColor = [UIColor clearColor];
  freqLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
  freqLabel.text = freqText;
  freqLabel.numberOfLines = 1;
  freqLabel.textAlignment = NSTextAlignmentCenter;
  [freqLabel sizeToFit];
  freqLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [self.currentChildViewController.view addSubview:freqLabel];
  
  durationDot.alpha = 0.f;
  durationLabel.alpha = 0.f;
  verificationDot.alpha = 0.f;
  verificationLabel.alpha = 0.f;
  frequencyDot.alpha = 0.f;
  freqLabel.alpha = 0.f;
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelYOffset-[durationLabel]"
                                                                                               options:0
                                                                                               metrics:@{@"labelYOffset":@(buttonYOffset + buttonSize.height + 5)}
                                                                                                 views:@{@"durationLabel":durationLabel}]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelYOffset-[verificationLabel]"
                                                                                               options:0
                                                                                               metrics:@{@"labelYOffset":@(buttonYOffset + buttonSize.height + 5)}
                                                                                                 views:@{@"verificationLabel":verificationLabel}]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelYOffset-[freqLabel]"
                                                                                               options:0
                                                                                               metrics:@{@"labelYOffset":@(buttonYOffset + buttonSize.height + 5)}
                                                                                                 views:@{@"freqLabel":freqLabel}]];
  
  [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:durationLabel
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:durationDot
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                  multiplier:1.f
                                                                                    constant:0]];
  
  [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:verificationLabel
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:verificationDot
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                  multiplier:1.f
                                                                                    constant:0]];

  [self.currentChildViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:freqLabel
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:frequencyDot
                                                                                   attribute:NSLayoutAttributeCenterX
                                                                                  multiplier:1.f
                                                                                    constant:0]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[startButton(startWidth)]"
                                                                                               options:0
                                                                                               metrics:@{@"startWidth":@([[UIScreen mainScreen] bounds].size.width*WIDTH_FACTOR)}
                                                                                                 views:@{@"startButton":startButton}]];
  
  [self.currentChildViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-startYOffset-[startButton(40)]"
                                                                                               options:0
                                                                                               metrics:@{@"startYOffset":@(self.currentChildViewController.view.frame.size.height*.80)}
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
  [UIView animateWithDuration:.37f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     durationDot.alpha = 1.f;
                     durationLabel.alpha = 1.f;
                     verificationDot.alpha = 1.f;
                     verificationLabel.alpha = 1.f;
                     frequencyDot.alpha = 1.f;
                     freqLabel.alpha = 1.f;
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
    if ([obj isKindOfClass:[DTDotElement class]]){
      duration = ((DTDotElement*)obj).dotNumber;
      [self.creationDictionary setObject:[duration stringValue] forKey:@"duration"];
      [durationDot setDotNumber:((DTDotElement*)obj).dotNumber];
    }
  }];
}

- (void)selectVerification:(UIButton *)button
{
  DTSelectionSheet *verifySheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetVerification];
  [verifySheet showInView:self.currentChildViewController.view];
  [verifySheet didCompleteWithSelectedObject:^(id obj){
    
    NSLog(@"this is verification: %@", obj);
    if ([obj isKindOfClass:[DTDotElement class]]){
      #warning it's gonna come up that the verification type is weakly tied to this element -- shouldn't always rely on the tag being the correct type :/
      verificationType = [NSNumber numberWithInt:((DTDotElement*)obj).tag];
      [self.creationDictionary setObject:[verificationType stringValue] forKey:@"verification"];
      [verificationDot setDotImage:[Verification imageForType:((DTDotElement*)obj).tag]];
    }
  }];
}

- (void)selectFrequency:(UIButton *)button
{
  DTSelectionSheet *freqSheet = [DTSelectionSheet selectionSheetWithType:DTSelectionSheetFrequency];
  [freqSheet showInView:self.currentChildViewController.view];
  [freqSheet didCompleteWithSelectedObject:^(id obj){
    
    NSLog(@"this is the frequency count: %@", obj);
    if ([obj isKindOfClass:[DTDotElement class]]){
      freqCount = ((DTDotElement*)obj).dotNumber;
      [self.creationDictionary setObject:[freqCount stringValue] forKey:@"frequency"];
      [frequencyDot setDotNumber:((DTDotElement*)obj).dotNumber];
    }
  }];
}

- (void)attemptChallengeCreation:(UIButton *)b
{
  __block BOOL failedTest = YES;
  [self.creationDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop){
    if (obj && [obj isKindOfClass:[NSString class]] && ![obj isEqual:[NSNull null]]) {
      if (((NSString*)obj).length > 0) {
        failedTest = NO;
      }else {
        failedTest = YES;
        *stop = YES;
      }
    }else {
      failedTest =YES;
      *stop = YES;
    }
  }];
  
  if (!failedTest) {
    ChallengeRequest *challengeRequest = [[ChallengeRequest alloc] initWithContext:((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext];
    [challengeRequest setDelegate:self];
    [challengeRequest createChallenge:self.creationDictionary];
  }
  else{
    UIAlertView *nope = [[UIAlertView alloc] initWithTitle:@"Nope!" message:@"Try again, you're just missing like maybe even just one thing -- you can do it!" delegate:nil cancelButtonTitle:@"PUT CHIPS IN A SANDWICH!" otherButtonTitles:nil];
    [nope show];
  }
}

- (void) challengeSuccessfullyCreated:(Challenge*)challenge
{
  [self transitionShareChallengeController];
}

- (void) requestDidError:(NSError*)err
{
  NIDINFO(@"Challenge Creation failed  :( with error: %@",err);
  UIAlertView *chFail = [[UIAlertView alloc] initWithTitle:@"Challenge Creation Failed with Error description" message:[[err userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
  [chFail show];
}

#pragma mark END OF CHALLENGE CREATION LOOP BACK TO BEGINNING

- (void)transitionShareChallengeController
{
//  CGFloat width = CGRectGetWidth(self.view.bounds);
  CGFloat height = CGRectGetHeight(self.view.bounds);
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformMakeTranslation(0, height);
  
  UIViewController *nextViewController = [self nextViewController];
  
  // Containment
  [self addChildViewController:nextViewController];
  [self.currentChildViewController willMoveToParentViewController:nil];
  
  nextViewController.view.transform = transform;

  UIAlertView *broughtToYouBy = [[UIAlertView alloc] initWithTitle:@"THAT SURE WAS FUN!" message:@"Unfortunately this is as far as challenge creation goes for now. Sharing and other stuff should be on this screen don't you think? Suggestions welcome!" delegate:self cancelButtonTitle:@"RYAN GOSLING AND LIV TYLER THINK YOU'RE FLY" otherButtonTitles:nil];

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
                            [broughtToYouBy show];
                          }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  
  UIViewController *newChallengeCreation = [[CreateChallengeViewController alloc] init];
  [self presentViewController:newChallengeCreation animated:YES completion:^{
    [newChallengeCreation didMoveToParentViewController:self];
    [self.currentChildViewController removeFromParentViewController];
    self.currentChildViewController = newChallengeCreation;
    
    NSLog(@"take it from the top");
  }];
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


// --> in case I should do a fake auth for the fake user and user creation

//Auth *userA = [[Auth alloc] init];
//Auth *userB = [[Auth alloc] init];
//Auth *userC = [[Auth alloc] init];
//UserRequest *req = [[UserRequest alloc] initWithContext:self.managedObjectContext];
//
//req.delegate = self;
//[req createUser:userA.username withPassword:userA.password additionalParameters:nil];
//[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
//userA.userId = tempUser.userId;
//
//AuthenticationRequest* req1 = [[AuthenticationRequest alloc] initWithContext:self.managedObjectContext];
//req1.delegate = self;
//[req1 logoutDevice];
//
//[req createUser:userB.username withPassword:userB.password additionalParameters:nil];
//[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
//userB.userId = tempUser.userId;
//[req1 logoutDevice];
//
//[req createUser:userC.username withPassword:userC.password additionalParameters:nil];
//[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
//userC.userId = tempUser.userId;
//[req1 logoutDevice];
//
//[req1 loginUser:userA.username withPassword:userA.password];
//[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeForRequest]];
//STAssertTrue(authSuccess, @"authentication was unusccessful");

@end
