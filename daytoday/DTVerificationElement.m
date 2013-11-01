//
//  DTVerificationElement.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTVerificationElement.h"
#import <QuartzCore/QuartzCore.h>

@interface VerificationSectionLayer : CAShapeLayer
@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;
@end

@implementation VerificationSectionLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
  if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"])
    return YES;
  else
    return [super needsDisplayForKey:key];
}

- (id)initWithLayer:(id)layer
{
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[VerificationSectionLayer class]]) {
      self.startAngle = [(VerificationSectionLayer *)layer startAngle];
      self.endAngle = [(VerificationSectionLayer *)layer endAngle];
    }
  }
  return self;
}

@end



@interface DTVerificationElement ()
@end

@implementation DTVerificationElement {
  //dot view contains all the dot slices
  UIView *_dotView;
}

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, center.x, center.y);
  
  CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
  CGPathCloseSubpath(path);
  
  return path;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _dotView = [[UIView alloc] initWithFrame:frame];
      [_dotView setBackgroundColor:[UIColor whiteColor]];
      [self insertSubview:_dotView atIndex:0]; // making sure the dotview is the bottomest
      
      self.dotRadius = MIN(frame.size.width/2.f, frame.size.height/2.f) - 10;
      self.dotCenter = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
    }
    return self;
}

- (void)drawVerificationSection
{
  CALayer *parentLayer = [_dotView layer];
  [parentLayer addSublayer:[self createSectionLayer]];
  NSArray *dotSliceLayers = [parentLayer sublayers];
  
  CGPathRef path = CGPathCreateArc(_dotCenter, _dotRadius, ((VerificationSectionLayer *)[dotSliceLayers objectAtIndex:0]).startAngle, ((VerificationSectionLayer *)[dotSliceLayers objectAtIndex:0]).endAngle);
  
  [((VerificationSectionLayer *)[dotSliceLayers objectAtIndex:0]) setPath:path];
  CFRelease(path);
  
}

- (void)setDotCenter:(CGPoint)dotCenter
{
  [_dotView setCenter:dotCenter];
  _dotCenter = CGPointMake(_dotView.frame.size.width/2.f, _dotView.frame.size.height/2.f);
}

- (void)setDotRadius:(CGFloat)dotRadius
{
  _dotRadius = dotRadius;
  CGPoint origin = _dotView.frame.origin;
  CGRect frame = CGRectMake(origin.x+_dotCenter.x-dotRadius, origin.y+_dotCenter.y-dotRadius, dotRadius*2, dotRadius*2);
  _dotCenter = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
  [_dotView setFrame:frame];
  [_dotView.layer setCornerRadius:_dotRadius];
}

- (VerificationSectionLayer *)createSectionLayer
{
  VerificationSectionLayer *dotSlice = [VerificationSectionLayer layer];
  [dotSlice setZPosition:0];
  [dotSlice setStrokeColor:[UIColor whiteColor].CGColor];
  [dotSlice setLineWidth:0.f];
  
  //set the start and end angles by hand to test
  [dotSlice setStartAngle:M_PI_2*3];
  [dotSlice setEndAngle:0];
  
  return dotSlice;
}













































@end
