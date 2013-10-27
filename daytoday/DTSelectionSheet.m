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
#import "DTInfiniteScrollView.h"
#import "DTDotElement.h"
#import "UIColor+SR.h"

@interface DTSelectionSheet () {
  NSInteger _currentPage;
}

//possibly temp vars for category scrollview templating
@property (nonatomic,retain) UIScrollView *categoryImagesScroll;
@property (nonatomic,retain) UIScrollView *selectionScroll;
@property (nonatomic,retain) NSArray *categoryImages;

@property (copy) void (^completionBlock)();

@end

@implementation DTSelectionSheet

NSString static *DURATION_TITLE = @"SELECT DURATION";
NSString static *VERIFICATION_TITLE = @"SELECT VERIFICATION";
NSString static *REPETITION_TITLE = @"SELECT NUMBER OF REPETIONS PER DAY";
NSString static *CATEGORY_TITLE = @"SELECT CATEGORY";

CGFloat const TRANSITION_DURATION = .42f;
CGFloat const VIEW_HEIGHT_PERCENT = .65f;

NSInteger static MAX_DURATION = 60;
NSInteger static MAX_REPETITION = 8;

+ (id)selectionSheetWithType:(DTSelectionSheetType)type
{
  return [[DTSelectionSheet alloc] initWithFrame:CGRectZero withType:type];
}

- (id)initWithFrame:(CGRect)frame withType:(DTSelectionSheetType)type
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.7f]];
    sheetType = type;
    self.titleText = [self titleForType];
    [self collectionForType];
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
    [self setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.7f]];
    self.titleText = [NSString stringWithString:t];
    //do something objs -- but they should contain views with tags if using the infinite scroll view -- so...yeah check them?
  }
  return self;
}

- (NSString *)titleForType
{
  NSString *title = @"";
  switch (sheetType) {
    case DTSelectionSheetDuration:
      return DURATION_TITLE;
      break;
    case DTSelectionSheetVerification:
      return VERIFICATION_TITLE;
      break;
    case DTSelectionSheetRepetition:
      return REPETITION_TITLE;
      break;
    case DTSelectionSheetCategory:
      return CATEGORY_TITLE;
      break;
    default:
      return @"TITLE NOT SET";
      break;
  }
  
  return title;
}

- (void)collectionForType
{
  NSMutableArray *collection = [[NSMutableArray alloc] init];
  //TODO clean up this -- getting messy
  NSMutableArray *images = [[NSMutableArray alloc] init];

  switch (sheetType) {
    case DTSelectionSheetDuration:
      for (int i = 0; i < MAX_DURATION; i++) {
        DTDotElement *dot = [[DTDotElement alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 80.f)
                                                  andColorGroup:[DTDotColorGroup durationSelectionColorGroup]
                                                      andNumber:[NSNumber numberWithInt:i+1]];
        dot.tag = i;  //critical for dtinfinitescroll

        UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectionButton setFrame:dot.bounds];
        [selectionButton setTag:i];
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
        dot.tag = i; //critical for dtinfinitescroll

        UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectionButton setFrame:dot.bounds];
        [selectionButton setTag:i];
        [selectionButton setBackgroundColor:[UIColor clearColor]];
        [selectionButton addTarget:self action:@selector(didMakeSelection:) forControlEvents:UIControlEventTouchUpInside];
        
        [dot addSubview:selectionButton];
        
        [collection addObject:dot];
      }
      break;
      case DTSelectionSheetCategory:
      for (int i = 0; i < 10; i++) {
        UIView *image = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 320.f)];
        [image setBackgroundColor:[UIColor randomColor]];
        image.tag = i;

        [images addObject:image];

        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f/2.f, 40.f)];
        [dot setBackgroundColor:[UIColor randomColor]];
        dot.tag = i;

        UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectionButton setFrame:dot.bounds];
        [selectionButton setTag:i];
        [selectionButton setBackgroundColor:[UIColor clearColor]];
//        [selectionButton addTarget:self action:@selector(didMakeSelection:) forControlEvents:UIControlEventTouchUpInside];

        [dot addSubview:selectionButton];

        [collection addObject:dot];
      }
    default://noop
      break;
  }

  if ([images count] > 0)
    self.categoryImages = [NSArray arrayWithArray:images];

  if ([collection count] > 0)
    self.selectionArray = [NSArray arrayWithArray:collection];
  else
    self.selectionArray = nil; //TODO should this be nil or should this error out?

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

  if (sheetType == DTSelectionSheetCategory) {
    self.categoryImagesScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                               selectionLabel.frame.origin.y + selectionLabel.frame.size.height + 15.f,
                                                                               320.f,
                                                                               320.f)];
    [self.categoryImagesScroll setDelegate:self];
    [self.categoryImagesScroll setPagingEnabled:YES];

    self.categoryImagesScroll.contentSize = CGSizeMake(320.*[self.categoryImages count], 320.);
    
    for (int i = 0; i < [self.categoryImages count]; i++) {
      [((UIView*)[self.categoryImages objectAtIndex:i]) setFrame:CGRectMake(320*i,
                                                                            0,
                                                                            320.f,
                                                                            320.f)];
      [self.categoryImagesScroll addSubview:[self.categoryImages objectAtIndex:i]];
    }
    ///////////////*********************************************************//////////////////////////////
    CGFloat static SCROLL_PADDING = 20.f;

    self.selectionScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f,
                                                                          self.categoryImagesScroll.frame.origin.y + self.categoryImagesScroll.frame.size.height + 15.f,
                                                                          320.f/1.f,
                                                                          40.f)];
    [self.selectionScroll setDelegate:self];
    [self.selectionScroll setPagingEnabled:NO];
//    [self.selectionScroll setClipsToBounds:NO];

    self.selectionScroll.contentSize = CGSizeMake((320.f)*[self.selectionArray count], 40.f);
//    self.selectionScroll.contentOffset = CGPointMake(SCROLL_PADDING+(160.f*.80)/2.f, 0.f);
//    self.selectionScroll.contentInset = UIEdgeInsetsMake(0.,
//                                                         160.,//SCROLL_PADDING+(160.f*.80)/2.f,
//                                                         0,
//                                                         160.f);//SCROLL_PADDING+(160.f*.80)/2.f);
    
    
    for (int i = 0; i < [self.selectionArray count]; i++) {
      [((UIView*)[self.selectionArray objectAtIndex:i]) setFrame:CGRectMake((120.f+(2*SCROLL_PADDING)-(120.f*1.f))/2.f,
                                                                            0.f,
                                                                            (120.f*1.f),
                                                                            40.f)];
      
      UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(i*(120.f+(2*SCROLL_PADDING)) + (4*SCROLL_PADDING),
                                                                       0,
                                                                       120.f+(2*SCROLL_PADDING),
                                                                       40)];
      [containerView setBackgroundColor:[UIColor randomColor]];
      [containerView setAlpha:.5];
      
      [containerView addSubview:[self.selectionArray objectAtIndex:i]];
      
//      [((UIView *)[self.selectionArray objectAtIndex:i]) setClipsToBounds:NO];
      [self.selectionScroll addSubview:containerView];
    }
    
    ///////////////*********************************************************//////////////////////////////
    [self addSubview:self.categoryImagesScroll];
    [self addSubview:self.selectionScroll];
  }
  else {
  //cannot include infinite scroll views in a constraint based layout because inherent
  //view tileing has a non-trivial contentsize (larger than the contained visible objects)
  DTInfiniteScrollView *sv = [[DTInfiniteScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                                    selectionLabel.frame.origin.y + selectionLabel.frame.size.height + 15.f,
                                                                                    320.f,
                                                                                    80.f)
                                                                   views:self.selectionArray];
  [self addSubview:sv];
  }
  
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
  if (sheetType == DTSelectionSheetCategory) {
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLine(2)]-2-[selectionLabel(30)]-460-[bottomLine(2)]"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  }
  else {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLine(2)]-2-[selectionLabel(30)]-85-[bottomLine(2)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
  }

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton]-10-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
}

#pragma mark - Return Selected Object Method

- (void)didCompleteWithSelectedObject:(void (^)(id obj))block
{
  self.completionBlock = [block copy];
}

- (void)selectionForButton:(UIButton *)b
{
//  self.completionBlock([self.selectionArray objectAtIndex:b.tag]);
//  [self dismiss];
}

#pragma mark - Showing and dismissing methods

- (void)showInView:(UIView *)view
{
  [self viewPreparation];

	[view addSubview:self];

  //layout Selection Sheet in superview
  if (sheetType == DTSelectionSheetCategory) {
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|"
                                                                 options:0
                                                                 metrics:@{ @"height": @(view.frame.size.height)}
                                                                   views:@{@"self": self}] ];
  }
  
  else {
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|"
                                                                 options:0
                                                                 metrics:@{ @"height": @(view.frame.size.height*VIEW_HEIGHT_PERCENT)}
                                                                   views:@{@"self": self}] ];
  }
  
//  NSDictionary *metrics = @{ @"height": @(view.frame.size.height*VIEW_HEIGHT_PERCENT)};
//  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:@{@"self": self}] ];

  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"self": self}]];

  [self.superview layoutIfNeeded];
  [self animateIntoView];
}

#pragma mark UIScrollView Delegate Methods

//categoryImagesScroll
//selectionScroll

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  if([scrollView isEqual:scrollViewA]) {
//    CGPoint offset = scrollViewB.contentOffset;
//    offset.y = scrollViewA.contentOffset.y;
//    [scrollViewB setContentOffset:offset];
//  } else {
//    CGPoint offset = scrollViewA.contentOffset;
//    offset.y = scrollViewB.contentOffset.y;
//    [scrollViewA setContentOffset:offset];
//  }
//}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
  CGFloat pageWidth = (self.selectionScroll.frame.size.width)/2.f + 0 /* Optional Photo app like gap between images */;
  
  _currentPage = floor((self.selectionScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  
  NSLog(@"Dragging - You are now on page %i", _currentPage);
}

-(void) scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
  
  CGFloat pageWidth = (self.selectionScroll.frame.size.width)/2.f + 0;
  
  int newPage = _currentPage;
  
  if (velocity.x == 0) // slow dragging not lifting finger
  {
    newPage = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
  }
  else
  {
    newPage = velocity.x > 0 ? _currentPage + 1 : _currentPage - 1;
    
    if (newPage < 0)
      newPage = 0;
    if (newPage > self.selectionScroll.contentSize.width / pageWidth)
      newPage = ceil(self.selectionScroll.contentSize.width / pageWidth) - 1.0;
  }
  
  NSLog(@"Dragging - You will be on %i page (from page %i)", newPage, _currentPage);
  
  *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  if (scrollView == self.selectionScroll) {
//
////    [self.categoryImagesScroll setContentOffset:[scrollView contentOffset]];
//  }
////  else {
////    [self.categoryImagesScroll setContentOffset:[scrollView contentOffset]];
////  }
//}


- (void)animateIntoView
{
  self.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
  [UIView animateWithDuration:TRANSITION_DURATION
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.transform = CGAffineTransformMakeTranslation(0, 0);
                   }
                   completion:NULL];
}

- (void)dismiss {
	if (!self.superview) return;

  __block CGRect f = self.frame;
	[UIView animateWithDuration:TRANSITION_DURATION
                   animations:^{
                     f.origin.y += f.size.height;
                     self.frame = f;
                   }
                   completion:^(BOOL finished) {
                    [self removeFromSuperview];
                   }];
}

@end
