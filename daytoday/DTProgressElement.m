//
//  DTProgressElement.m
//  daytoday
//
//  Created by pasmo on 10/1/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTProgressElement.h"

@interface DTProgressElement () {
    CGFloat endRadius;
    CGFloat progressUnits; //length of progressElement coverage in discreet day-circle-units
    DTProgressColorGroup *progressColorGroup;
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)radius angleInDegrees:(double)angleInDegrees;

@end

@implementation DTProgressElement

@synthesize percent,leftCenter,rightCenter,radius;

static CGFloat END_PADDING = 3.f;
static CGFloat DOT_STROKE_WIDTH = 1.5f;

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
    
    [progressPath addLineToPoint:CGPointMake(progressPath.currentPoint.x+progressUnits, progressPath.currentPoint.y)];

    angleInDegrees = 270;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:endCenter
                                               radius:endRadius
                                       angleInDegrees:angleInDegrees];
        [progressPath addLineToPoint:CGPointMake(progressUnits+point.x, point.y)];
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

- (CGPoint)rightCenter
{
    return CGPointMake(endRadius+progressUnits+END_PADDING, self.frame.size.height/2.f);
}

- (CGPoint)leftCenter
{
    return CGPointMake(endRadius+END_PADDING, self.frame.size.height/2.f);
}

@end
