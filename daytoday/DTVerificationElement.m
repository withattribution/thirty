//
//  DTVerificationElement.m
//  daytoday
//
//  Created by pasmo on 10/31/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTVerificationElement.h"
#import <QuartzCore/QuartzCore.h>

@interface SectionLayer : CAShapeLayer <NSCopying>

@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;
@property (nonatomic,assign) BOOL isVerified;

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

-(void)setIsVerified:(BOOL)isVerified
{
  _isVerified = isVerified;
  [self setFillColor:(isVerified) ? [UIColor blueColor].CGColor : [UIColor lightGrayColor].CGColor];
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

- (id)copyWithZone:(NSZone *)zone
{
  SectionLayer *layerCopy = [[SectionLayer allocWithZone:zone] init];
  [layerCopy setStartAngle:_startAngle];
  [layerCopy setEndAngle:_endAngle];
  [layerCopy setIsVerified:_isVerified];
  
  [layerCopy setBackgroundColor:[UIColor clearColor].CGColor];
//  [layerCopy setStrokeColor:[UIColor whiteColor].CGColor];
  [layerCopy setZPosition:0];
  [layerCopy setLineWidth:2.5f];
  
  return layerCopy;
}

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
  CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
  NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
  if(!currentAngle) currentAngle = from;
  [arcAnimation setFromValue:currentAngle];
  [arcAnimation setToValue:to];
  [arcAnimation setDelegate:delegate];
  [arcAnimation setValue:to forKey:key];
  [arcAnimation setValue:key forKey:@"id"];
  [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
  [self addAnimation:arcAnimation forKey:key];
  [self setValue:to forKey:key];
}
@end

@interface DTVerificationElement ()
- (void)updateTimerFired:(NSTimer *)timer;
- (SectionLayer *)createSectionLayer:(BOOL)verificationStatus;
@end

@implementation DTVerificationElement {
  //backing view contains all the verification sections
  UIView *_backing;

  BOOL isSectionProgress;
  NSInteger _activeSection;
  SectionLayer *_section;

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
      _backing = [[UIView alloc] initWithFrame:frame];
      [_backing setBackgroundColor:[UIColor whiteColor]];
      [self addSubview:_backing];
      
      _startSectionAngle = M_PI_2*3;
      _animationSpeed = 1.f;
      _animations = [[NSMutableArray alloc] init];

      self.dotRadius = MIN(frame.size.width/2.f, frame.size.height/2.f) - 0;
      self.dotCenter = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
      
      UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(isHoldingSection:)];
      [press setMinimumPressDuration:.01];
      [self addGestureRecognizer:press];
      
       _activeSection = -1;
      isSectionProgress = NO;
    }
    return self;
}

- (void)setType:(DTVerificationType)type
{
  UIImageView *verificationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., self.frame.size.width*.65, self.frame.size.height*.65)];
  verificationImage.image = [Verification imageForType:type];
  [verificationImage setCenter:self.dotCenter];
  [verificationImage.layer setBorderColor:[UIColor blueColor].CGColor];
  [verificationImage.layer setBorderWidth:1.2f];
  [verificationImage.layer setCornerRadius:self.dotRadius*.65];
  [verificationImage.layer setMasksToBounds:YES];
//  [verificationImage.layer setShouldRasterize:YES];
  [self addSubview:verificationImage];
  [self bringSubviewToFront:verificationImage];
//  UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0., 0., self.frame.size.width*.65, self.frame.size.height*.65)];
//  [circle setCenter:self.dotCenter];
//  [circle.layer setBorderColor:[UIColor darkGrayColor].CGColor];
//  [circle.layer setBorderWidth:2.f];
//  [circle setAlpha:0.8f];
//  [circle.layer setCornerRadius:self.dotRadius*.65];
//  [circle setBackgroundColor:[UIColor orangeColor]];
//  [self addSubview:circle];
//  [self bringSubviewToFront:circle];
}


- (void)isHoldingSection:(UIGestureRecognizer *)g
{
  if ( [g isKindOfClass:[UILongPressGestureRecognizer class]] && [g state] == UIGestureRecognizerStateBegan )
  {
    isSectionProgress = YES;

    CALayer *parentLayer = [_backing layer];
    NSArray *sectionLayers = [parentLayer sublayers];

    if (!_section) {
      _section = [[sectionLayers objectAtIndex:_activeSection] copy];
      [_section setIsVerified:YES];
      [parentLayer addSublayer:_section];
    }

    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationSpeed*(.8)]; //slightly faster for forward animation
    
    NSNumber *presentationLayerCurrentAngle = [[_section presentationLayer] valueForKey:@"sectionAngle"];
    [_section createArcAnimationForKey:@"sectionAngle"
                             fromValue:(presentationLayerCurrentAngle == nil) ? [NSNumber numberWithFloat:_section.startAngle] : presentationLayerCurrentAngle
                               toValue:[NSNumber numberWithFloat:_section.endAngle]
                              Delegate:self];
    [CATransaction commit];
  }
  if ( [g isKindOfClass:[UILongPressGestureRecognizer class]] && [g state] == UIGestureRecognizerStateEnded )
  {
    if (isSectionProgress)
    {
      NSNumber *presentationLayerCurrentAngle = [[_section presentationLayer] valueForKey:@"sectionAngle"];
      
      [CATransaction begin];
      [CATransaction setAnimationDuration:_animationSpeed];
      [_section createArcAnimationForKey:@"sectionAngle"
                               fromValue:presentationLayerCurrentAngle
                                 toValue:[NSNumber numberWithFloat:_section.startAngle]
                                Delegate:self];
      [CATransaction commit];
    }
  }
}

- (void)setDotCenter:(CGPoint)dotCenter
{
  [_backing setCenter:dotCenter];
  _dotCenter = CGPointMake(_backing.frame.size.width/2.f, _backing.frame.size.height/2.f);
}

- (void)setDotRadius:(CGFloat)dotRadius
{
  _dotRadius = dotRadius;
  CGPoint origin = _backing.frame.origin;
  CGRect frame = CGRectMake(origin.x+_dotCenter.x-dotRadius, origin.y+_dotCenter.y-dotRadius, dotRadius*2, dotRadius*2);
  _dotCenter = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
  [_backing setFrame:frame];
  [_backing.layer setCornerRadius:_dotRadius];
}

- (void)reloadData:(BOOL)animated
{
  if (_dataSource)
  {
    CALayer *parentLayer = [_backing layer];
    NSArray *sectionLayers = [parentLayer sublayers];

    CGFloat startToAngle = 0.0;
    CGFloat endToAngle = startToAngle;

    NSUInteger sectionCount = [_dataSource numberOfSectionsInVerificationElement:self];
    NSUInteger completedCount = [_dataSource numberOfCompletedSectionsInVerificationElement:self];
    
    _activeSection = (sectionCount > completedCount) ? completedCount : -1;
    
    CGFloat angle = (M_PI * 2) / MAX(sectionCount, 1);

    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationSpeed];

    [self setUserInteractionEnabled:NO];
    
    BOOL isFirstStarting = ([sectionLayers count] == 0 && sectionCount);
    for (int index = 0; index < sectionCount; index++)
    {
      SectionLayer *layer;
      endToAngle += angle;
      CGFloat startFromAngle = _startSectionAngle + startToAngle;
      CGFloat endFromAngle = _startSectionAngle + endToAngle;

      if (index >= [sectionLayers count])
      {
        layer = [self createSectionLayer:(index < completedCount)];
        if (isFirstStarting)
          startFromAngle = endFromAngle = _startSectionAngle;
        [parentLayer addSublayer:layer];
      }
      
      [layer setStartAngle:startToAngle+_startSectionAngle];
      [layer setEndAngle:endToAngle+_startSectionAngle];
      
      if (animated)
      {
        [layer createArcAnimationForKey:@"startAngle"
                              fromValue:[NSNumber numberWithFloat:startFromAngle]
                                toValue:[NSNumber numberWithFloat:startToAngle+_startSectionAngle]
                               Delegate:self];
        [layer createArcAnimationForKey:@"endAngle"
                              fromValue:[NSNumber numberWithFloat:endFromAngle]
                                toValue:[NSNumber numberWithFloat:endToAngle+_startSectionAngle]
                               Delegate:self];
      }else {
        CGPathRef path = CGPathCreateArc(_dotCenter, _dotRadius, layer.startAngle, layer.endAngle);
        [layer setPath:path];
        CFRelease(path);
      }
      startToAngle = endToAngle;
    }
    //if the number of completed and the number required are equal this interface is locked
    //in the fully completed state
    if (_activeSection >= 0) [self setUserInteractionEnabled:YES];

    [CATransaction setDisableActions:NO];
    [CATransaction commit];
  }
}

- (void)updateTimerFired:(NSTimer *)timer
{
  CALayer *parentLayer = [_backing layer];
  NSArray *sectionLayers = [parentLayer sublayers];

  if (isSectionProgress) {
    NSNumber *presentationLayerEndAngle = [[_section presentationLayer] valueForKey:@"sectionAngle"];
    CGFloat interpolatedEndAngle = [presentationLayerEndAngle floatValue];
    
    CGPathRef path = CGPathCreateArc(_dotCenter, _dotRadius, _section.startAngle, interpolatedEndAngle);
    [_section setPath:path];
    CFRelease(path);
  }
  else {
    [sectionLayers enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL *stop){
    
      NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
      CGFloat interpolatedStartAngle = [presentationLayerStartAngle floatValue];

      NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
      CGFloat interpolatedEndAngle = [presentationLayerEndAngle floatValue];
      
      CGPathRef path = CGPathCreateArc(_dotCenter, _dotRadius, interpolatedStartAngle, interpolatedEndAngle);
      [obj setPath:path];
      CFRelease(path);
    }];
  }
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
  if (animationCompleted && [[anim valueForKey:@"id"] isEqualToString:@"sectionAngle"])
  {
    isSectionProgress = NO;
  
    if ([[anim valueForKey:@"sectionAngle"] floatValue]== _section.endAngle)
    {
      if ([_delegate respondsToSelector:@selector(verificationElement:didVerifySection:)])
        [_delegate verificationElement:self didVerifySection:_activeSection];
      
      CALayer *parentLayer = [_backing layer];
      NSArray *sectionLayers = [parentLayer sublayers];
      [parentLayer replaceSublayer:[sectionLayers objectAtIndex:_activeSection] with:_section];
      [_section removeAllAnimations];
      _section = nil;
      
      //disable interface until reloaddata is called
      [self setUserInteractionEnabled:NO];
    }
  }

  [_animations removeObject:anim];

  if ([_animations count] == 0) {
    [_animationTimer invalidate];
    _animationTimer = nil;
  }
}

- (SectionLayer *)createSectionLayer:(BOOL)verificationStatus
{
  SectionLayer *section = [SectionLayer layer];
  [section setIsVerified:verificationStatus];
  
  [section setBackgroundColor:[UIColor clearColor].CGColor];
//  [section setStrokeColor:[UIColor whiteColor].CGColor];
  [section setZPosition:0];
  [section setLineWidth:2.5f];
  
  return section;
}

@end
