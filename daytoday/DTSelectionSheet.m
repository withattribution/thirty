//
//  DTSelectionSheet.m
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

//this is an action sheet which will do the following

//1) present itself from the bottom of a view controller and cover about 70% of the screen
//1-1) will transition in a manner consistent with a regular UIActionSheet
//2) will have a section for a uiscroll view on top with selectable states
//2-1) will have a label that centered at the top of the action sheet
//3) will have a large text view area with descriptors for the selectable state (either static or changing depending on the state)
//4) will have a dimiss button which will set the state
//5) will have an area outside of the view that if touched will dismiss the view and save the state of the selection
//6) may blur the background view depending on how fly i'm feeling

#import "DTSelectionSheet.h"
#import "UIColor+SR.m"

@implementation DTSelectionSheet
@synthesize titleText;

CGFloat const TransitionDuration = .2;
CGFloat const VIEW_HEIGHT_PERCENT = 0.65f;

+ (id)selectionSheetWithTitle:(NSString *)t
{
  return [[DTSelectionSheet alloc] initWithFrame:CGRectZero withTitle:t];
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)t
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleText = [NSString stringWithString:t];
    self.backgroundColor = [UIColor orangeColor];
  }
  return self;
}

#pragma mark - Preparation before showing view

- (void)viewPreparation
{
  //this prepares the skeletal layout of the basic dtactionsheet
  //draw the line
  //place the pointer image for selection
  //place the uiscrollView
  //draw the bottom line
  //draw either a fixted uitextview or draw a uiscrollview with a series of uitextviews
  //draw the cancel button
  
  UIView *topLine = [[UIView alloc] init];
  topLine.translatesAutoresizingMaskIntoConstraints = NO;
  [topLine setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:1.f]];
  [self addSubview:topLine];
  
  UILabel *selectionLabel = [[UILabel alloc] init];
  selectionLabel.textColor = [UIColor colorWithWhite:.9 alpha:1.f];
  selectionLabel.backgroundColor = [UIColor clearColor];
  selectionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
  selectionLabel.text = [self.titleText uppercaseString];
  selectionLabel.numberOfLines = 1;
  selectionLabel.textAlignment = NSTextAlignmentCenter;
  [selectionLabel sizeToFit];
  selectionLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [selectionLabel setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:1.f]];
  [self addSubview:selectionLabel];
  
  UIScrollView *sv = [[UIScrollView alloc] init];
  [sv setBackgroundColor:[UIColor purpleColor]];
  sv.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:sv];
  
  UIView *bottomLine = [[UIView alloc] init];
  bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
  [bottomLine setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:1.f]];
  [self addSubview:bottomLine];
  
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel as a button field");
  [cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
  cancelButton.titleLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.f];
  cancelButton.backgroundColor = [UIColor clearColor];
  [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  [cancelButton setBackgroundColor:[UIColor colorWithWhite:0.4f alpha:1.f]];
  [self addSubview:cancelButton];
  
  //these are the constraints for drawing purposes
  NSDictionary *views = NSDictionaryOfVariableBindings(topLine,selectionLabel,sv,bottomLine,cancelButton);
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLine]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selectionLabel]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cancelButton]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLine(2)]-2-[selectionLabel(30)]-[sv(140)]-[bottomLine(2)]"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton]-10-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  //scrollview layout constraints
  /*****************************************************************************/
  
  UIView* previousLab = nil;
  NSDictionary *svMetrics = @{ @"svheight": @120 , @"svwidth": @120};
  
  for (int i=0; i<30; i++) {
    UIView *lab = [UIView new];
    lab.translatesAutoresizingMaskIntoConstraints = NO;
    lab.backgroundColor = [UIColor randomColor];
    [sv addSubview:lab];
    
    [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[lab(svheight)]"
                                                               options:0
                                                               metrics:svMetrics
                                                                 views:@{@"lab":lab}]];
    if (!previousLab) { // first one, pin to top
      [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[lab(svwidth)]"
                                                                 options:0
                                                                 metrics:svMetrics
                                                                   views:@{@"lab":lab}]];
    } else { // all others, pin to previous
      [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[prev]-(10)-[lab(svwidth)]"
                                                                 options:0
                                                                 metrics:svMetrics
                                                                   views:@{@"lab":lab, @"prev":previousLab}]];
    }
    previousLab = lab;
  }
  // last one, pin to bottom and right, this dictates content size height
  [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lab(svwidth)]-(10)-|"
                                                             options:0
                                                             metrics:svMetrics
                                                               views:@{@"lab":previousLab}]];
  
  [sv addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab(svheight)]-(10)-|"
                                                             options:0
                                                             metrics:svMetrics
                                                               views:@{@"lab":previousLab}]];
  
  /*****************************************************************************/
  
}

#pragma mark - Showing and dismissing methods

- (void)showInView:(UIView *)view {
  //	[self prepare:view.frame];
  [self viewPreparation];
	[view addSubview:self];
  
  //layout Selection Sheet in superview
  NSDictionary *metrics = @{ @"height": @(view.frame.size.height*VIEW_HEIGHT_PERCENT)};
  NSDictionary *views = NSDictionaryOfVariableBindings(self);
  
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:views];
  [view addConstraints:verticalConstraints];
  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
  [view addConstraints:horizontalConstraints];
  
	// slide from bottom
  self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
  [UIView animateWithDuration:TransitionDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.transform = CGAffineTransformMakeTranslation(0, 0);
  } completion:NULL];
}

- (void)dismiss {
	if (!self.superview) return;
  
  __block CGRect f = self.frame;
	[UIView animateWithDuration:TransitionDuration animations:^{
    f.origin.y += f.size.height;
    self.frame = f;
	} completion:^(BOOL finished) {
    //		[self removeFromSuperview];
    
    [self performSelector:@selector(showInView:) withObject:self.superview afterDelay:2.0];
	}];
}

@end
