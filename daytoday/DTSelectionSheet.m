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
#import "DTDotElement.h"
#import "DTInfiniteScrollView.h"

@interface DTSelectionSheet ()

@property (copy) void (^completionBlock)();

@end

@implementation DTSelectionSheet

CGFloat const TransitionDuration = .2f;
CGFloat const VIEW_HEIGHT_PERCENT = 0.65f;

NSInteger static MAX_DURATION = 60;
NSInteger static MAX_REPETITION = 8;

+ (id)selectionSheetWithTitle:(NSString *)t type:(DTSelectionSheetType)type
{
  return [[DTSelectionSheet alloc] initWithFrame:CGRectZero withTitle:t type:type];
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)t type:(DTSelectionSheetType)type
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleText = [NSString stringWithString:t];
    [self setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.7f]];
    [self collectionForType:type];
  }
  return self;
}

+ (id)selectionSheetWithTitle:(NSString *)t objects:(NSArray *)objs
{
  return [[DTSelectionSheet alloc] initWithFrame:CGRectZero withTitle:t objects:objs];
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)t objects:(NSArray *)objs
{
  self = [super initWithFrame:frame];
  if (self) {
    self.titleText = [NSString stringWithString:t];
    [self setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.7f]];
  }
  return self;
}

- (void)collectionForType:(DTSelectionSheetType)type
{
  NSMutableArray *collection = [[NSMutableArray alloc] init];
  switch (type) {
    case DTSelectionSheetDuration:
      for (int i = 0; i < MAX_DURATION; i++) {
        DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 80.f)
                                                  andColorGroup:[DTDotColorGroup durationSelectionColorGroup]
                                                      andNumber:[NSNumber numberWithInt:i+1]];
        dot.tag = i;

        UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectionButton setFrame:dot.bounds];
        [selectionButton setTag:i+1];
        [selectionButton setBackgroundColor:[UIColor clearColor]];
        [selectionButton addTarget:self action:@selector(selectionForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [dot addSubview:selectionButton];
        
        [collection addObject:dot];
      }
      break;
    case DTSelectionSheetVerification:
      
      break;
    case DTSelectionSheetRepetition:
      for (int i = 0; i < MAX_REPETITION; i++) {
        DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 80.f)
                                                  andColorGroup:[DTDotColorGroup durationSelectionColorGroup]
                                                      andNumber:[NSNumber numberWithInt:i+1]];
        
        UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectionButton setFrame:dot.bounds];
        [selectionButton setTag:i+1];
        [selectionButton setBackgroundColor:[UIColor clearColor]];
        [selectionButton addTarget:self action:@selector(didMakeSelection:) forControlEvents:UIControlEventTouchUpInside];
        
        [dot addSubview:selectionButton];
        
        [collection addObject:dot];
      }
      break;
    default://noop
      break;
  }

  self.selectionArray = [NSArray arrayWithArray:collection];
  if ([collection count] > 0)
    self.selectionArray = [NSArray arrayWithArray:collection];
  else self.selectionArray = nil; //TODO should this be nil or should this error out?
  
}

- (void)selectionForButton:(UIButton *)b
{
  NSLog(@"this is the button tag that was selected: %d",b.tag);
}

#pragma mark - Preparation before showing view

- (void)viewPreparation
{
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
  
  //cannot include infinite scroll views in a constraint based layout because inherent
  //view tileing has a non-trivial contentsize (larger than the contained visible objects)
  DTInfiniteScrollView *sv = [[DTInfiniteScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                                    selectionLabel.frame.origin.y + selectionLabel.frame.size.height + 15.f,
                                                                                    320.f,
                                                                                    80.f)
                                                                   views:self.selectionArray];
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
  NSDictionary *views = NSDictionaryOfVariableBindings(topLine,selectionLabel,bottomLine,cancelButton);
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLine]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selectionLabel]|"
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
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLine(2)]-2-[selectionLabel(30)]-85-[bottomLine(2)]"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton]-10-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];

}

#pragma mark - Return Selected Object Method

//this block should say -- hey my button was clicked and it contains an index
//use this index in the globally available objects array to return to check to see if the object is valid
//and if so then return it -- it does not need the user to pass variables in but it needs to return vars
// then execute the completion block?

- (void)didCompleteWithSelectedObject:(void (^)(id obj))block 
{
  NSArray *array = @[@"1",@"2",@"3"];
  block([array firstObject]);
//  self.completionBlock = [block copy];
//  id *obj = NSLog(@"is this even possible");
//  return obj;

}

//- (void)yourMethod:(return_type (^)(var_type))blockName;

//return_type (^blockName)(var_type) = ^return_type (var_type varName)
//{
//  // ...
//};

- (id)returnABool:(BOOL (^)(id obj, NSUInteger idx))block
{
  id (^selectedObject)(NSInteger) = ^id (NSInteger idx){
    return [_selectionArray objectAtIndex:idx];
  };
  
//  id (^test)(id obj, NSUInteger idx, BOOL *stop);
//
//  if (<#condition#>) {
//    return YES;
//  }
  
  
  return selectedObject;
}

//
//test = ^(id obj, NSUInteger idx, BOOL *stop) {
//  
//  if (idx < 5) {
//    if ([filterSet containsObject: obj]) {
//      return YES;
//    }
//  }
//  return NO;
//};

#pragma mark - Showing and dismissing methods

- (void)showInView:(UIView *)view {
  //	[self prepare:view.frame];
  [self viewPreparation];
	[view addSubview:self];
  
  //layout Selection Sheet in superview
  NSDictionary *metrics = @{ @"height": @(view.frame.size.height*VIEW_HEIGHT_PERCENT)};
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|"
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:@{@"self": self}];
  [view addConstraints:verticalConstraints];

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"self": self}];
  [view addConstraints:horizontalConstraints];

	// slide from bottom
  self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
  [UIView animateWithDuration:TransitionDuration
                        delay:.1f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.transform = CGAffineTransformMakeTranslation(0, 0);
                   }
                   completion:NULL];
}

- (void)dismiss {
	if (!self.superview) return;

  __block CGRect f = self.frame;
	[UIView animateWithDuration:TransitionDuration
                   animations:^{
                     f.origin.y += f.size.height;
                     self.frame = f;
                   }
                   completion:^(BOOL finished) {
                    [self removeFromSuperview];
	}];
}

@end
