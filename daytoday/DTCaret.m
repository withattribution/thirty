//
//  DTCaret.m
//  daytoday
//
//  Created by pasmo on 10/8/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTCaret.h"

//I know everyone is as excited about the caret as I am so here it is!
// the upsidedown point thingy we've all been dreaming of

@implementation DTCaret

static CGFloat CARET_STROKE_WIDTH = 1.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawCaret];
    }
    return self;
}

- (void)drawCaret
{
    //Default caret points downward
    UIBezierPath *caretPath = [UIBezierPath bezierPath];
    [caretPath moveToPoint:CGPointMake(0.0, 0.0)];
    [caretPath addLineToPoint:CGPointMake(self.frame.size.width,0.0)];
    [caretPath addLineToPoint:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0)];
    [caretPath addLineToPoint:CGPointMake(0.0, 0.0)];
    
    CAShapeLayer *caretShape  = [CAShapeLayer layer];
    caretShape.opacity        = 1.0;
    caretShape.fillColor      = [UIColor lightGrayColor].CGColor;
    caretShape.strokeColor    = [UIColor lightGrayColor].CGColor;
    caretShape.lineWidth      = CARET_STROKE_WIDTH;
    caretShape.lineCap        = kCALineCapRound;
    caretShape.lineJoin       = kCALineJoinRound;
    caretShape.path           = caretPath.CGPath;

    [self.layer addSublayer:caretShape];
}

- (void) rotateCaretPointLeft
{
    self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
}

- (void) rotateCaretPointRight
{
    self.transform = CGAffineTransformRotate(self.transform, M_PI_2*(3.f));
}

- (void) rotateCaretPointUp
{
    self.transform = CGAffineTransformRotate(self.transform, M_PI);
}
@end
