//
//  DTVerificationElement.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTVerificationElement.h"
#import <QuartzCore/QuartzCore.h>

#import "UIColor+SR.h"

@interface SectionLayer : CAShapeLayer
@property (nonatomic,assign) double startAngle;
@property (nonatomic,assign) double endAngle;
- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end

@implementation SectionLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
  if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
    return YES;
  }
  else {
    return [super needsDisplayForKey:key];
  }
}

- (id)initWithLayer:(id)layer
{
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[SectionLayer class]]) {
      self.startAngle = [(SectionLayer *)layer startAngle];
      self.endAngle = [(SectionLayer *)layer endAngle];
    }
  }
  return self;
}

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
  CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
  NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
  if(!currentAngle) currentAngle = from;
  [arcAnimation setFromValue:currentAngle];
  [arcAnimation setToValue:to];
  [arcAnimation setDelegate:delegate];
  [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
  [self addAnimation:arcAnimation forKey:key];
  [self setValue:to forKey:key];
}
@end

@interface DTVerificationElement ()
- (void)updateTimerFired:(NSTimer *)timer;
- (SectionLayer *)createSectionLayer;
@end

@implementation DTVerificationElement {
  //dot view contains all the dot slices
  UIView *_dotView;
  
  NSTimer *_animationTimer;
  NSMutableArray *_animations;
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
      [self addSubview:_dotView];
      
      _startSectionAngle = M_PI_2*3;
      _animationSpeed = 13.f;
      _animations = [[NSMutableArray alloc] init];

      self.dotRadius = MIN(frame.size.width/2.f, frame.size.height/2.f) - 2;
      self.dotCenter = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
    }
    return self;
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

- (void)reloadData
{
  if (_dataSource)
  {
    CALayer *parentLayer = [_dotView layer];
    NSArray *sectionLayers = [parentLayer sublayers];
    
    double startToAngle = 0.0;
    double endToAngle = startToAngle;
    
    NSUInteger sectionCount = [_dataSource numberOfSectionsInVerificationElement:self];

    CGFloat angle = (M_PI * 2) / MAX(sectionCount, 1);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationSpeed];
    NSLog(@"_animationSpeed: %f",_animationSpeed);

    [_dotView setUserInteractionEnabled:NO];
    
    BOOL isFirstStarting = ([sectionLayers count] == 0 && sectionCount);
    for (int index = 0; index < sectionCount; index++)
    {
      SectionLayer *layer;
      
      endToAngle += angle;
      
      double startFromAngle = _startSectionAngle + startToAngle;
      double endFromAngle = _startSectionAngle + endToAngle;
      
      if (index >= [sectionLayers count])
      {
        layer = [self createSectionLayer];
        if (isFirstStarting)
          startFromAngle = endFromAngle = _startSectionAngle;
        [parentLayer addSublayer:layer];
      }
      
      [layer createArcAnimationForKey:@"startAngle"
                            fromValue:[NSNumber numberWithDouble:startFromAngle]
                              toValue:[NSNumber numberWithDouble:startToAngle+_startSectionAngle]
                             Delegate:self];
      [layer createArcAnimationForKey:@"endAngle"
                            fromValue:[NSNumber numberWithDouble:endFromAngle]
                              toValue:[NSNumber numberWithDouble:endToAngle+_startSectionAngle]
                             Delegate:self];
      startToAngle = endToAngle;
    }
    
    [_dotView setUserInteractionEnabled:YES];
    
    [CATransaction setDisableActions:NO];
    [CATransaction commit];
    
  }
}

- (void)updateTimerFired:(NSTimer *)timer
{
  CALayer *parentLayer = [_dotView layer];
  NSArray *sectionLayers = [parentLayer sublayers];

  [sectionLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop){
  
    NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
    CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
    
    NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
    CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
    
    CGPathRef path = CGPathCreateArc(_dotCenter, _dotRadius, interpolatedStartAngle, interpolatedEndAngle);
    [obj setPath:path];
    CFRelease(path);

  }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
  if (_animationTimer == nil) {
    static float timeInterval = 1.0/60.0;

    _animationTimer = [NSTimer timerWithTimeInterval:timeInterval
                                              target:self
                                            selector:@selector(updateTimerFired:)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
  }

  [_animations addObject:anim];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)animationCompleted
{
  [_animations removeObject:anim];
  
  if ([_animations count] == 0) {
    [_animationTimer invalidate];
    _animationTimer = nil;
  }
}

- (SectionLayer *)createSectionLayer
{
  SectionLayer *dotSlice = [SectionLayer layer];
//  [dotSlice setFillColor:[UIColor randomColor].CGColor];
  [dotSlice setZPosition:0];
  [dotSlice setStrokeColor:[UIColor whiteColor].CGColor];
  [dotSlice setLineWidth:1.f];

//  float radius = 100.f;
//  CALayer *theDonut = [CALayer layer];
//  theDonut.bounds = CGRectMake(0,0, radius, radius);
//  theDonut.cornerRadius = radius/2;
//  theDonut.backgroundColor = [UIColor clearColor].CGColor;
//  
//  theDonut.borderWidth = radius/5;
//  theDonut.borderColor = [UIColor orangeColor].CGColor;
//  
//  [self.layer addSublayer:theDonut];

  return dotSlice;
}

@end
