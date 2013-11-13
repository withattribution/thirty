//
//  ChallengeDayCommentTableView.m
//  daytoday
//
//  Created by pasmo on 11/11/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//


#import "UIColor+SR.h"
#import "ChallengeDayCommentTableView.h"

@interface ChallengeDayCommentTableView ()

@property (nonatomic, assign) CGFloat initialTouchPositionY;
@property (nonatomic, assign) CGFloat initialVerticalCenter;
@property (nonatomic, assign) NSUInteger panningVelocityYThreshold;
@property (nonatomic, assign) NSUInteger panningYThreshold;


- (CGFloat)resettedCenter;

@end


@implementation ChallengeDayCommentTableView {
  UIPanGestureRecognizer *_panGesture;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setBackgroundColor:[UIColor clearColor]];
      [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      [self setShowsVerticalScrollIndicator:NO];
      [self setContentInset:UIEdgeInsetsZero];
      [self setDelegate:self];
      [self setDataSource:self];
      
      UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 320., 50.)];
      [tableHeader setBackgroundColor:[UIColor redColor]];
      self.tableHeaderView = tableHeader;
      
      _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopViewVerticalCenterWithRecognizer:)];
      [self addGestureRecognizer:_panGesture];

      self.panningVelocityYThreshold = 100;
      self.panningYThreshold = 150;
    }
    return self;
}

#pragma mark - pan gesture recognizer

- (void)updateTopViewVerticalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
  CGPoint currentTouchPoint     = [recognizer locationInView:self];
  CGFloat currentTouchPositionY = currentTouchPoint.y;
  
//  NSLog(@"the current touch y: %f",currentTouchPositionY);

  if (recognizer.state == UIGestureRecognizerStateBegan) {
    self.initialTouchPositionY = currentTouchPositionY;
    self.initialVerticalCenter = self.center.y;
    
//    NSLog(@"the initialVerticalCenter y: %f",self.initialVerticalCenter);

  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    
    CGFloat panAmount = self.initialTouchPositionY - currentTouchPositionY;
    


    CGFloat newCenterPosition = self.initialVerticalCenter - panAmount;
      NSLog(@"the pan amount: %f & newcenter %f",panAmount, newCenterPosition);
    
//    NSLog(@"the new center: %f",newCenterPosition);
    
//    if ( newCenterPosition < self.resettedCenter ) {
//      NSLog(@"\n \n nope \n \n ");
//      newCenterPosition = self.resettedCenter;
//    }
    [self updateTopViewVerticalCenter:newCenterPosition];
  }
//  else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
//    CGPoint currentVelocityPoint = [recognizer velocityInView:self];
//    CGFloat currentVelocityY     = currentVelocityPoint.y;
//
//    if ((/*viewIsPastAnchor || */currentVelocityY > self.panningVelocityYThreshold)) {
//      [self anchorTopView];
//    }
//    //else if ((/*viewIsPastAnchor || */ -currentVelocityY > self.panningVelocityYThreshold)) {
//    //  [self anchorTopViewTo:ECLeft];
//    //}
//    else {
//      [self resetTopView];
//    }
//  }
}

- (void)resetTopView
{
  
  [UIView animateWithDuration:0.25f animations:^{
    [self updateTopViewVerticalCenter:self.resettedCenter];
  } completion:^(BOOL finished) {
    [self updateTopViewVerticalCenter:self.resettedCenter];
  }];
}

//- (CGFloat)anchorLeftTopViewCenter
//{
//  if (self.anchorLeftPeekAmount) {
//    return -self.resettedCenter + self.anchorLeftPeekAmount;
//  } else if (self.anchorLeftRevealAmount) {
//    return -self.resettedCenter + (CGRectGetWidth(self.view.bounds) - self.anchorLeftRevealAmount);
//  } else {
//    return NSNotFound;
//  }
//}

- (CGFloat)resettedCenter
{
  return (CGRectGetHeight(self.superview.bounds) / 3.0f);
}

- (void)updateTopViewVerticalCenter:(CGFloat)newVerticalCenter
{
//  CGPoint center = self.center;
  self.center = CGPointMake(self.center.x, newVerticalCenter);
  self.layer.position = self.center;
  
  
  
  
//  self.frame = CGRectMake(0., self.center.y - self.frame.origin.y, 320., 480.);
  
//  self.frame = CGRectMake(0., <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
  
//  NSLog(@"here here here new center: %@ and center: %f",CGPointCreateDictionaryRepresentation(self.center), newVerticalCenter);
//  self.topViewSnapshot.frame = self.topView.frame;
//  if (self.topViewCenterMoved) self.topViewCenterMoved(newHorizontalCenter);
}


- (void)anchorTopView
{
  CGFloat newCenter = self.center.y;
  
//  if (side == ECLeft) {
//    newCenter = self.anchorLeftTopViewCenter;
//  } else if (side == ECRight) {
//    newCenter = self.anchorRightTopViewCenter;
//  }
  
  newCenter = self.superview.center.y;
  
  [UIView animateWithDuration:0.25f animations:^{
    [self updateTopViewVerticalCenter:newCenter];
  } completion:^(BOOL finished){
    [self updateTopViewVerticalCenter:newCenter];
  }];
}


#pragma mark - Table View Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [[UITableViewCell alloc] init];
  cell.backgroundColor = [UIColor randomColor];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

@end
