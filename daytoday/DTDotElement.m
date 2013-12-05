//
//  DTDotElement.m
//  daytoday
//
//  Created by pasmo on 9/5/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import "DTDotElement.h"
#import <QuartzCore/QuartzCore.h>
#import "NSCalendar+equalWithGranularity.h"

@interface DTDotColorGroup ()

{NSCalendar *_localCalendar;}

@end

@implementation DTDotColorGroup

@synthesize textColor,strokeColor,fillColor;

+(DTDotColorGroup *) currentActiveDayColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor blackColor];
  dcg.fillColor        = [UIColor whiteColor];
  dcg.textColor        = [UIColor grayColor];
  return dcg;
}

+(DTDotColorGroup *) accomplishedDayColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor clearColor];
  dcg.fillColor        = [UIColor blueColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) someParticipationAndStillActiveColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor orangeColor];
  dcg.fillColor        = [UIColor lightGrayColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) someParticipationButFailedColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor blackColor];
  dcg.fillColor        = [UIColor darkGrayColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) futuresSoBrightYouGottaWearShadesColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor lightGrayColor];
  dcg.fillColor        = [UIColor lightGrayColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) durationSelectionColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor colorWithWhite:.8f alpha:1.f];
  dcg.fillColor        = [UIColor colorWithWhite:.4f alpha:.8f];
  dcg.textColor        = [UIColor lightGrayColor];
  return dcg;
}


+(DTDotColorGroup *) failedDayColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor clearColor];
  dcg.fillColor        = [UIColor lightGrayColor];
  dcg.textColor        = [UIColor grayColor];
  return dcg;
}

+(DTDotColorGroup *) repetitionCountColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor clearColor];
  dcg.fillColor        = [UIColor blueColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) challengersCountColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor clearColor];
  dcg.fillColor        = [UIColor yellowColor]; //try to get okra color
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) summaryDayColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor whiteColor];
  dcg.fillColor        = [UIColor colorWithRed:230.f/255.f green:230.f/255.f blue:230.f/255.f alpha:1.f];
  dcg.textColor        = [UIColor grayColor];
  return dcg;
}

+(DTDotColorGroup *) summaryPercentageColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor clearColor];
  dcg.fillColor        = [UIColor blueColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+(DTDotColorGroup *) daySelectionColorGroup
{
  DTDotColorGroup *dcg = [[DTDotColorGroup alloc] init];
  dcg.strokeColor      = [UIColor lightGrayColor];
  dcg.fillColor        = [UIColor grayColor];
  dcg.textColor        = [UIColor whiteColor];
  return dcg;
}

+ (DTDotColorGroup *) colorGroupForChallengeDay:(PFObject *)challengeDay withDate:(NSDate *)date
{
  DTDotColorGroup *dg = [DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup];
  NSCalendar *referenceCalendar = [DTCommonUtilities commonCalendar];
  
  //current day
  if ([referenceCalendar ojf_isDate:date
                        equalToDate:[NSDate date]
                    withGranularity:NSDayCalendarUnit]){
    
    if (![[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue] &&
        [[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] == 0)
    {
      dg = [DTDotColorGroup currentActiveDayColorGroup];
    }
    if (![[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue] &&
        ([[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] > 0 ))
    {
      dg = [DTDotColorGroup someParticipationAndStillActiveColorGroup];
    }
    if ([[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue])
    {
      dg = [DTDotColorGroup accomplishedDayColorGroup];
    }
    
  }
  
  //past day
  if ([referenceCalendar ojf_compareDate:date
                                  toDate:[NSDate date]
                       toUnitGranularity:NSCalendarUnitDay] == NSOrderedAscending) {
    
    if (![[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue] &&
        [[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] == 0)
    {
      dg = [DTDotColorGroup failedDayColorGroup];
    }
    if (![[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue] &&
        ([[challengeDay objectForKey:kDTChallengeDayTaskCompletedCountKey] intValue] > 0 ))
    {
      dg = [DTDotColorGroup someParticipationButFailedColorGroup];
    }
    if ([[challengeDay objectForKey:kDTChallengeDayAccomplishedKey] boolValue])
    {
      dg = [DTDotColorGroup accomplishedDayColorGroup];
    }
    
  }
  
  //future day
//  if ([referenceCalendar ojf_compareDate:date
//                           toDate:[NSDate date]
//                toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
//    dg = [DTDotColorGroup futuresSoBrightYouGottaWearShadesColorGroup];
//  }
  
  return dg;
}

@end

@interface DTDotElement () {
  DTDotColorGroup *dotColorGroup;
  UILabel *_dotLabel;
  UIImageView *_dotImageView;
}

- (void)dotRadius;
- (void)drawDTDotElement;
- (NSNumber*)numberFromDate:(NSDate *)d;
- (CGFloat)strokeWidthForFrame;
- (void)drawLabelWithNumber:(NSNumber *)number;
- (void)placeInscribedImage:(UIImage *)img;

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees;

@end

@implementation DTDotElement

static CGFloat DOT_PADDING = 3.f;
static CGFloat DOT_STROKE_SCALE = 0.03f; //scale stroke widdth to some percentage of frame height

+ (DTDotElement *)buildForChallengeDay:(PFObject *)challengeDay andDate:(NSDate *)date
{
  return [[DTDotElement alloc] initWithFrame:CGRectMake(0., 0., 50., 50.) andColorGroup:[DTDotColorGroup colorGroupForChallengeDay:challengeDay withDate:date] andDate:date];
}

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
      _dotNumber = num;
      
      [self dotRadius];
      [self drawDTDotElement];
      [self drawLabelWithNumber:num];
  }
  return self;
}

- (void)redrawNumber:(NSNumber *)num
{
  [self drawLabelWithNumber:num];
}

- (id)initWithFrame:(CGRect)f
      andColorGroup:(DTDotColorGroup *)dg
          andDate:(NSDate *)date;
{
  self = [super initWithFrame:f];
  if (self) {
      dotColorGroup = dg;
      _dotDate = date;
      _dotNumber = [self numberFromDate:self.dotDate];

      [self dotRadius];
      [self drawDTDotElement];
      [self drawLabelWithNumber:self.dotNumber];
  }
  return self;
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
    [self placeInscribedImage:img];
  }
  return self;
}

#pragma mark CUSTOM DTDotElement Setters 

- (void)setDotNumber:(NSNumber *)dotNumber
{
  if (_dotLabel) {
    [_dotLabel removeFromSuperview];
  }
  _dotNumber = dotNumber;
  [self drawLabelWithNumber:dotNumber];
}

- (void)setDotImage:(UIImage *)dotImage
{
  if (_dotImageView) {
    [_dotImageView removeFromSuperview];
  }
  [self placeInscribedImage:dotImage];
}

- (void)setDotDate:(NSDate *)dotDate {
  if (_dotLabel) {
    [_dotLabel removeFromSuperview];
  }
  _dotNumber = [self numberFromDate:self.dotDate];
  [self drawLabelWithNumber:self.dotNumber];
}

- (NSNumber*)numberFromDate:(NSDate *)d
{
//  NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
//  return [NSNumber numberWithInt:[[cal components:NSDayCalendarUnit fromDate:d] day]];

  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  return [f numberFromString:[[DTCommonUtilities displayDayFormatter] stringFromDate:d]];
}

- (void)dotRadius
{
  self.radius = (self.frame.size.height - (2*DOT_PADDING)) / 2.f;
}

- (void)drawDTDotElement
{
  UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
  
  CGPoint startPoint = [self pointOnCircleWithCenter:self.center radius:self.radius angleInDegrees:0];

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

- (CGRect) rectForInscribedImage
{
  CGFloat angle = M_PI/6.0f;
  CGFloat boundLength = (2*(cos(angle)*self.radius));
//  CGFloat boundHeight = (2*(sin(angle)*self.radius));

  //always square
  return CGRectMake(self.frame.origin.x,self.frame.origin.y, boundLength*(1.15f), boundLength*(1.15f));
}

- (void)placeInscribedImage:(UIImage *)img
{
  _dotImageView = [[UIImageView alloc] initWithImage:img];
  [_dotImageView setFrame:[self rectForInscribedImage]];
  
  CALayer *roundedMaskLayer = _dotImageView.layer;
  [roundedMaskLayer setCornerRadius:self.radius];
  [roundedMaskLayer setBorderWidth:0];
  [roundedMaskLayer setMasksToBounds:YES];
  
  [self addSubview:_dotImageView];
  [_dotImageView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
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
  _dotLabel= [[UILabel alloc] initWithFrame:[self rectForInscribedLabel]];
  _dotLabel.textColor = dotColorGroup.textColor;
  _dotLabel.backgroundColor = [UIColor clearColor];
  _dotLabel.alpha = 1.0;
  _dotLabel.numberOfLines = 0;
  _dotLabel.textAlignment = NSTextAlignmentCenter;
  _dotLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];;
  _dotLabel.text = [number stringValue];
  _dotLabel.adjustsFontSizeToFitWidth = YES;
  _dotLabel.minimumScaleFactor = .25;
  [self addSubview:_dotLabel];
  [_dotLabel setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
}

- (CGPoint) pointOnCircleWithCenter:(CGPoint)center radius:(double)r angleInDegrees:(double)angleInDegrees
{
  float x = (float)(r * cos(angleInDegrees * M_PI / 180)) + r;
  float y = (float)(r * sin(angleInDegrees * M_PI / 180)) + r;
  return CGPointMake(x, y);
}

@end