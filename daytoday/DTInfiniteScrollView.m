//
//  DTInfiniteScrollView.m
//  daytoday
//
//  Created by pasmo on 10/22/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTInfiniteScrollView.h"
#import "UIColor+SR.h"

@interface DTInfiniteScrollView ()

@property (nonatomic, strong) NSArray *views;

@property (nonatomic, strong) NSMutableArray *visibleViews;
@property (nonatomic, strong) UIView *viewContainerView;

@property (nonatomic, retain) NSMutableArray *visibleIndices;

@end

@implementation DTInfiniteScrollView

- (id)initWithFrame:(CGRect)frame views:(NSArray *)views
{
  self = [super initWithFrame:frame];
  if (self) {
    self.views = [views copy];

    self.contentSize = CGSizeMake(1500, self.frame.size.height);
    self.visibleIndices = [[NSMutableArray alloc] init];
    _visibleViews = [[NSMutableArray alloc] init];
    
    _viewContainerView = [[UIView alloc] init];
//    self.viewContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    self.viewContainerView.frame = CGRectMake(0, 0, 100, 100.);

    [self addSubview:self.viewContainerView];
    
    [self.viewContainerView setUserInteractionEnabled:NO];
    
    // hide horizontal scroll indicator so our recentering trick is not revealed
    [self setShowsHorizontalScrollIndicator:NO];
  }
  return self;
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
  CGPoint currentOffset = [self contentOffset];
  CGFloat contentWidth = [self contentSize].width;


  CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
  CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
  
  if (distanceFromCenter > (contentWidth / 4.0))
  {
    self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
    
    // move content by the same amount so it appears to stay still
    for (UIView *v in self.visibleViews) {
      NSLog(@"count of visible views :%d", [self.visibleViews count]);
      CGPoint center = [self.viewContainerView convertPoint:v.center toView:self];
      center.x += (centerOffsetX - currentOffset.x);
      v.center = [self convertPoint:center toView:self.viewContainerView];
    }
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self recenterIfNecessary];
  
  // tile content in visible bounds
  CGRect visibleBounds = [self convertRect:[self bounds] toView:self.viewContainerView];
  CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
  CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
  
  [self tileViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}


#pragma mark - Label Tiling

//- (UILabel *)insertLabel
//{
//  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//  [label setNumberOfLines:3];
//  [label setText:@"1024 Block Street\nShaffer, CA\n95014"];
//  [label setBackgroundColor:[UIColor randomColor]];
//  [self.viewContainerView addSubview:label];
//  
//  return label;
//}

- (CGFloat)placeNewLabelOnRight:(CGFloat)rightEdge
{
  
//  UILabel *label = [self insertLabel];
  
  NSUInteger viewTag = ((UIView *)[self.visibleViews lastObject]).tag;
  
  NSLog(@"the tag inserted on the right: %d",viewTag);
  
  if (viewTag == ([self.views count] - 1) ) {
    viewTag = 0;
  }else {
    viewTag += 1;
  }
  
  UIView *insertView = (UIView *)[self.views objectAtIndex:viewTag];
//  [self.visibleViews addObject:label]; // add rightmost label at the end of the array
  [self.visibleViews addObject:insertView]; // add rightmost label at the end of the array
  
  [self.viewContainerView addSubview:insertView];

  
  CGRect frame = [insertView frame];
  frame.origin.x = rightEdge;
  frame.origin.y = [self.viewContainerView bounds].size.height - frame.size.height;
  [insertView setFrame:frame];
  
  return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnLeft:(CGFloat)leftEdge
{
//  UILabel *label = [self insertLabel];
  
  NSUInteger viewTag = ((UIView *)[self.visibleViews firstObject]).tag;
  if (viewTag == 0) {
    viewTag = ([self.views count] - 1);
  }else {
    viewTag -= 1;
  }
  
  NSLog(@"the tag inserted on the left: %d",viewTag);

  UIView *insertView = (UIView *)[self.views objectAtIndex:viewTag];

//  [self.visibleViews insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
  [self.visibleViews insertObject:insertView atIndex:0]; // add leftmost label at the beginning of the array
  [self.viewContainerView addSubview:insertView];

  CGRect frame = [insertView frame];
  frame.origin.x = leftEdge - frame.size.width;
  frame.origin.y = [self.viewContainerView bounds].size.height - frame.size.height;
  [insertView setFrame:frame];
  
  return CGRectGetMinX(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
  // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
  // to kick off the tiling we need to make sure there's at least one label
  if ([self.visibleViews count] == 0)
  {
    [self placeNewLabelOnRight:minimumVisibleX];
  }
  
  // add labels that are missing on right side
  UIView *lastView = [self.visibleViews lastObject];
  CGFloat rightEdge = CGRectGetMaxX([lastView frame]);
  while (rightEdge < maximumVisibleX)
  {
    rightEdge = [self placeNewLabelOnRight:rightEdge];
  }
  
  // add labels that are missing on left side
  UIView *firstView = self.visibleViews[0];
  CGFloat leftEdge = CGRectGetMinX([firstView frame]);
  while (leftEdge > minimumVisibleX)
  {
    leftEdge = [self placeNewLabelOnLeft:leftEdge];
  }
  
  // remove labels that have fallen off right edge
  lastView = [self.visibleViews lastObject];
  while ([lastView frame].origin.x > maximumVisibleX)
  {
//    NSLog(@"max fall off: %f",maximumVisibleX);
    [lastView removeFromSuperview];
    [self.visibleViews removeLastObject];
    lastView = [self.visibleViews lastObject];
  }
  
  // remove labels that have fallen off left edge
  firstView = self.visibleViews[0];
  while (CGRectGetMaxX([firstView frame]) < minimumVisibleX)
  {
//    NSLog(@"min fall off: %f",minimumVisibleX);
    [firstView removeFromSuperview];
    [self.visibleViews removeObjectAtIndex:0];
    firstView = self.visibleViews[0];
  }
}


@end
