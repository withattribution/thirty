//
//  DTProgressRow.m
//  daytoday
//
//  Created by pasmo on 12/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTProgressRow.h"

@interface DTProgressRow ()

@property (nonatomic,assign) CGFloat dotPadding;
@property (nonatomic,assign) NSUInteger dotCount;
@property (nonatomic,strong) NSArray *rowChallengeDays;
@property (nonatomic,strong) NSArray *rowDates;

@property (nonatomic,strong) DTProgressElement *progressElement;

+ (CGFloat)paddingForRowInset:(CGFloat)rowInset numberOfDTDots:(NSUInteger)dotCount frame:(CGRect)frame;

@end

@implementation DTProgressRow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _rowInset = 0.f;
      _dotCount = 0;
    }
    return self;
}

- (void)setRowInset:(CGFloat)rowInset
{
  _rowInset = rowInset;

  if (_dataSource)
    self.dotCount = [_dataSource numberOfDaysForProgressRow:self];
  
  self.dotPadding = [DTProgressRow paddingForRowInset:self.rowInset numberOfDTDots:self.dotCount frame:self.frame];
}

+ (CGFloat)paddingForRowInset:(CGFloat)rowInset numberOfDTDots:(NSUInteger)dotCount frame:(CGRect)frame
{
//  NIDINFO(@"screen width: %f",[[UIScreen mainScreen] bounds].size.width);
//  NIDINFO(@"row inset: %f",(rowInset*2));
//  NIDINFO(@"dot count minus 1: %d",(dotCount -1));
//  NIDINFO(@"frame size height: %f",frame.size.height);
//  NIDINFO(@"result: %f",([[UIScreen mainScreen] bounds].size.width-(rowInset*2) - (dotCount * frame.size.height))/dotCount);
  return ((([[UIScreen mainScreen] bounds].size.width-(rowInset*2)) - (dotCount * frame.size.height))/dotCount);
}

- (void)reloadData:(BOOL)animated date:(NSDate *)date
{
  if (_dataSource) {
    //compensate for changed row inset
    self.dotCount = [_dataSource numberOfDaysForProgressRow:self];
    self.dotPadding = [DTProgressRow paddingForRowInset:self.rowInset numberOfDTDots:self.dotCount frame:self.frame];

//    NIDINFO(@"dot padding: %f",self.dotPadding);
//    NIDINFO(@"dot inset: %f",self.rowInset);

    self.rowChallengeDays   = [_dataSource challengeDaysForProgressRow:self date:date];
    self.rowDates           = [_dataSource datesForProgressRow:self date:date];
    
//    NIDINFO(@"rowChallengeDays count: %ld",[self.rowChallengeDays count]);

    NSMutableArray *dtDotRow = [NSMutableArray new];
    for (int iterator = 0; iterator < [self.rowChallengeDays count]; iterator++)
    {
      PFObject *day = [self.rowChallengeDays objectAtIndex:iterator];
      NSDate *rowDate = [self.rowDates objectAtIndex:iterator];
      
      DTDotElement *dayDot = [DTDotElement buildForChallengeDay:day andDate:rowDate frame:self.frame];
      [dayDot setCenter:CGPointMake((self.rowInset+(self.dotPadding/2.f)) + (self.frame.size.height/2.f) + (iterator*self.dotPadding)+(iterator*self.frame.size.height),20.f)];
      [self addSubview:dayDot];
      [dtDotRow addObject:dayDot];
    }

    NSUInteger position            = ([_dataSource indexForDate:self date:date]+1);
    DTProgressRowEndStyle endStyle = [_dataSource endStyleForDate:date];

    CGFloat progressUnits = (position * (self.dotPadding + self.frame.size.height));
//    NIDINFO(@"units: %f",progressUnits);
    DTProgressElement *progressElement = [DTProgressElement buildForStyle:endStyle
                                                            progressUnits:progressUnits
                                                                    frame:CGRectMake(self.rowInset/2.f,
                                                                                     0.f,
                                                                                     self.frame.size.width-(1*self.rowInset),
                                                                                     self.frame.size.height)];
    [self insertSubview:progressElement atIndex:0];
  }
}

@end
