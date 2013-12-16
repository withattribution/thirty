//
//  DTProgressElement.m
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTProgressElement.h"

@implementation DTProgressColorGroup

+(DTProgressColorGroup *) summaryProgressBackground
{
  DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
  pcg.strokeColor = [UIColor redColor];
  pcg.fillColor   = [UIColor whiteColor];
  return pcg;
}

+(DTProgressColorGroup *) summaryProgressForeground
{
  DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
  pcg.strokeColor = [UIColor redColor];
  pcg.fillColor   = [UIColor redColor];
  return pcg;
}

+(DTProgressColorGroup *) snapshotProgress
{
  DTProgressColorGroup *pcg = [[DTProgressColorGroup alloc] init];
  pcg.strokeColor = [UIColor blueColor];
  pcg.fillColor   = [UIColor blueColor];
  return pcg;
}

@end

@interface DTProgressElement () {
    CGFloat endRadius;
    CGFloat progressUnits; //length of progressElement coverage in discreet DTDotElement units
    DTProgressColorGroup *progressColorGroup;
}

- (void)drawForStyle:(DTProgressRowEndStyle)style;
- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)radius angleInDegrees:(double)angleInDegrees;

@end

@implementation DTProgressElement

static CGFloat END_PADDING = 0.f;//3.f;
static CGFloat DOT_STROKE_WIDTH = 1.5f;

+ (DTProgressElement *)buildForStyle:(DTProgressRowEndStyle)style progressUnits:(CGFloat)units frame:(CGRect)frame
{
  return [[DTProgressElement alloc] initWithEndStyle:style andColorGroup:[DTProgressColorGroup snapshotProgress] progressUnits:units frame:frame];
}

- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units frame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    progressColorGroup = pcg;
    progressUnits = units;
    [self determineRoundedRadius];
    [self drawForStyle:style];
  }
  return self;
}

- (id)initWithEndStyle:(DTProgressRowEndStyle)style andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units
{
    CGRect GENERIC_PROGRESS_FRAME = CGRectMake(0.f, 0.f, 320.f, 40.f);

    self = [super initWithFrame:GENERIC_PROGRESS_FRAME];
    if (self) {
        progressColorGroup = pcg;
        progressUnits = units;
        [self determineRoundedRadius];
        [self drawForStyle:style];
    }
    return self;
}

- (id)initForSummaryElement:(CGFloat)p
{
    CGRect GENERIC_PROGRESS_FRAME = CGRectMake(0.f, 0.f, 320.f, 40.f);
    self = [super initWithFrame:GENERIC_PROGRESS_FRAME];
    if (self) {
        self.percent = p;
        
        progressColorGroup = [DTProgressColorGroup summaryProgressBackground];
        
        [self determineRoundedRadius];
        progressUnits = [self convertPercentToProgressUnits:1.0];
        [self drawRoundedProgressElement];
        
        progressUnits = [self convertPercentToProgressUnits:p];
        progressColorGroup = [DTProgressColorGroup summaryProgressForeground];
        [self drawRoundedProgressElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg withPercent:(CGFloat)p
{
    self = [super initWithFrame:frame];
    if (self) {
        self.percent = p;
        progressColorGroup = pcg;
        [self determineRoundedRadius];
        progressUnits = [self convertPercentToProgressUnits:p];
        [self drawRoundedProgressElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andColorGroup:(DTProgressColorGroup *)pcg progressUnits:(CGFloat)units
{
    self = [super initWithFrame:frame];
    if (self) {
        progressColorGroup = pcg;
        progressUnits = units;
        [self determineRoundedRadius];
    }
    return self;
}

- (void)drawForStyle:(DTProgressRowEndStyle)style
{
    switch (style) {
        case 0:
            [self drawFlatProgressElement];
            break;
        case 1:
            [self drawFlatLeftProgressElement];
            break;
        case 2:
            [self drawFlatRightProgressElement];
            break;
        case 3:
            [self drawRoundedProgressElement];
            break;
        default:
            //DTProgressRowEndUndefined draws nothing but DTProgressElement does return a valid frame
            break;
    }
}

- (void)drawFlatProgressElement
{
    CGPoint startPoint = CGPointMake(self.frame.origin.x - END_PADDING,self.frame.size.height);

    UIBezierPath *progressPath = [UIBezierPath bezierPath];

    [progressPath moveToPoint:startPoint];
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING, 0.0f)];
    [progressPath addLineToPoint:CGPointMake(self.frame.size.width+END_PADDING,progressPath.currentPoint.y)];
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x, self.frame.size.height)];
    [progressPath addLineToPoint:startPoint];

    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFlatLeftProgressElement
{
    CGPoint startPoint = CGPointMake(self.frame.origin.x-END_PADDING,0.0f);
    CGPoint endCenter = CGPointZero;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    
    [progressPath moveToPoint:startPoint];
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING,0.0f)];
    [progressPath addLineToPoint:CGPointMake(progressUnits, progressPath.currentPoint.y)];
    int sampleCount = 40;
    CGFloat angleInDegrees = 270;
    CGFloat delta = 180.0f/sampleCount;
    angleInDegrees = 270;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:CGPointMake(progressUnits+point.x, point.y)];
    }
    [progressPath addLineToPoint:CGPointMake(self.frame.origin.x-END_PADDING, progressPath.currentPoint.y)];
    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFlatRightProgressElement
{
    //Flat right is a special variant of the progress element that will only be drawn when the first day
    //exists in the current row, and the row-week is completed.
    progressUnits = (self.frame.size.width - END_PADDING);
    //length of the progress units always extends to the full right edge of the screen since the active day
    //is not in the current week-row.
    
    CGPoint endCenter = CGPointZero;
    CGPoint startPoint = [self pointOnCircleWithCenter:endCenter
                                                radius:endRadius
                                        angleInDegrees:90];

    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:startPoint];
    
    int sampleCount = 40;
    CGFloat delta = 180.0f/sampleCount;
    CGFloat angleInDegrees = 90;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:point];
    }
    [progressPath addLineToPoint:CGPointMake(progressUnits, progressPath.currentPoint.y)];
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x, self.frame.size.height)];
    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawRoundedProgressElement
{
    CGPoint endCenter = CGPointZero;
    CGPoint startPoint = [self pointOnCircleWithCenter:endCenter
                                                radius:endRadius
                                        angleInDegrees:90];

    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:startPoint];
    
    int sampleCount = 40;
    CGFloat delta = 180.0f/sampleCount;
    CGFloat angleInDegrees = 90;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:CGPointZero
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:point];
    }
    
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x+progressUnits-(2*endRadius), progressPath.currentPoint.y)];

    angleInDegrees = 270;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:CGPointMake(progressUnits-(2*endRadius)+point.x, point.y)];
    }

    [progressPath addLineToPoint:startPoint];
    
    [self drawFinalShapeWithPath:progressPath];
}

- (void)drawFinalShapeWithPath:(UIBezierPath *)path
{
    CAShapeLayer *progressShape  = [CAShapeLayer layer];
    progressShape.opacity        = 1.0;
    progressShape.position       = CGPointMake(END_PADDING,0.f);
    progressShape.fillColor      = progressColorGroup.fillColor.CGColor;
    progressShape.strokeColor    = progressColorGroup.strokeColor.CGColor;
    progressShape.lineWidth      = DOT_STROKE_WIDTH;
    progressShape.lineCap        = kCALineCapRound;
    progressShape.lineJoin       = kCALineJoinRound;
    progressShape.path           = path.CGPath;
    
    [self.layer addSublayer:progressShape];
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees
{
    float x = (float)(r * cos(angleInDegrees * M_PI / 180)) + r;
    float y = (float)(r * sin(angleInDegrees * M_PI / 180)) + r;
    return CGPointMake(x, y);
}

-(CGFloat) convertPercentToProgressUnits:(CGFloat)p
{
    return (self.frame.size.width - (2*END_PADDING) - (2*endRadius))*p;
}

-(void) determineRoundedRadius
{
  endRadius = (self.frame.size.height)/2.f;
}

//- (CGPoint)rightCenter
//{
//    return CGPointMake(endRadius+progressUnits+END_PADDING, self.frame.size.height/2.f);
//}
//
//- (CGPoint)leftCenter
//{
//    return CGPointMake(endRadius+END_PADDING, self.frame.size.height/2.f);
//}

@end
