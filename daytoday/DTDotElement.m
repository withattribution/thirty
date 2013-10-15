//
//  DTDotElement.m
//  daytoday
//
//  Created by pasmo on 9/5/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTDotElement.h"
#import "UIColor+SR.h"

@interface DTDotElement () {
    DTDotColorGroup *dotColorGroup;
}

- (void)dotRadius;
- (void)drawDTDotElement;
- (NSNumber*)numberFromDate:(NSDate *)d;
- (CGFloat)strokeWidthForFrame;
- (void)drawLabelWithNumber:(NSNumber *)number;

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees;

@end

@implementation DTDotElement
@synthesize radius,dotNumber,dotDate;

static CGFloat DOT_PADDING = 3.f;
static CGFloat DOT_STROKE_SCALE = 0.03f; //scale stroke widdth to some percentage of frame height

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawDTDotElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)f andColorGroup:(DTDotColorGroup *)dg;
{
    self = [super initWithFrame:f];
    if (self) {
        dotColorGroup = dg;
        
        [self dotRadius];
        [self drawDTDotElement];
    }
    return self;
}

- (id)initWithFrame:(CGRect)f
      andColorGroup:(DTDotColorGroup *)dg
          andNumber:(NSNumber *)num;
{
    self = [super initWithFrame:f];
    if (self) {
        dotColorGroup = dg;
        self.dotNumber = num;
        
        [self dotRadius];
        [self drawDTDotElement];
        [self drawLabelWithNumber:num];
    }
    return self;
}

- (id)initWithFrame:(CGRect)f
      andColorGroup:(DTDotColorGroup *)dg
          andDate:(NSDate *)date;
{
    self = [super initWithFrame:f];
    if (self) {
        dotColorGroup = dg;
        self.dotDate = date;
        self.dotNumber = [self numberFromDate:self.dotDate];

        [self dotRadius];
        [self drawDTDotElement];
        [self drawLabelWithNumber:self.dotNumber];
    }
    return self;
}

- (NSNumber*)numberFromDate:(NSDate *)d
{
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    return [NSNumber numberWithInt:[[cal components:NSDayCalendarUnit fromDate:d] day]];
}

- (id)initWithFrame:(CGRect)f
      andColorGroup:(DTDotColorGroup *)dg
           andImage:(UIImage *)img;
{
    self = [super initWithFrame:f];
    if (self) {
        dotColorGroup = dg;
        [self dotRadius];
        [self drawDTDotElement];
    }
    return self;
}

- (void)dotRadius
{
    self.radius = (self.frame.size.height - (2*DOT_PADDING)) / 2.f;
}

- (void)drawDTDotElement
{
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    CGPoint startPoint = [self pointOnCircleWithCenter:self.center radius:self.radius angleInDegrees:0];

//    CGPoint startPoint = CGPointMake(self.frame.origin.x - END_PADDING,
//                                     self.frame.size.height - (2*END_PADDING));

    int sampleCount = 80;
    [smoothedPath moveToPoint:startPoint];

    CGFloat delta = 360.0f/sampleCount;
    CGFloat angleInDegrees = 0;
    for (NSInteger i=1; i<sampleCount; i++) {
        angleInDegrees += delta;
        CGPoint point = [self pointOnCircleWithCenter:self.center radius:self.radius angleInDegrees:angleInDegrees];
        [smoothedPath addLineToPoint:point];
    }

    [smoothedPath addLineToPoint:startPoint];

    CAShapeLayer *dotShape   = [CAShapeLayer layer];
    dotShape.opacity         = 1.0;
    dotShape.position        = CGPointMake(DOT_PADDING,DOT_PADDING);
    dotShape.fillColor       = dotColorGroup.fillColor.CGColor;
    dotShape.strokeColor     = dotColorGroup.strokeColor.CGColor;
    dotShape.lineWidth       = [self strokeWidthForFrame];
    dotShape.lineCap         = kCALineCapRound;
    dotShape.lineJoin        = kCALineJoinRound;
    dotShape.path            = smoothedPath.CGPath;

    [self.layer addSublayer:dotShape];
}

-(CGFloat) strokeWidthForFrame
{
    return self.frame.size.height*DOT_STROKE_SCALE;
}

- (CGRect) rectForInscribedLabel
{
    CGFloat angle = M_PI/6.0f;
    CGFloat boundLength = (2*(cos(angle)*self.radius));
    CGFloat boundHeight = (2*(sin(angle)*self.radius));
    
    return CGRectMake(self.frame.origin.x,self.frame.origin.y, boundLength, boundHeight);
}

-(void) drawLabelWithNumber:(NSNumber *)number
{
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:[self rectForInscribedLabel]];
    numberLabel.textColor = dotColorGroup.textColor;
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.alpha = 1.0;
    numberLabel.numberOfLines = 0;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];;
    numberLabel.text = [number stringValue];
    numberLabel.adjustsFontSizeToFitWidth = YES;
    numberLabel.minimumScaleFactor = .25;
    [self addSubview:numberLabel];
    [numberLabel setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
}

- (CGPoint) pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees
{
    float x = (float)(r * cos(angleInDegrees * M_PI / 180)) + r;
    float y = (float)(r * sin(angleInDegrees * M_PI / 180)) + r;
    return CGPointMake(x, y);
}



@end
