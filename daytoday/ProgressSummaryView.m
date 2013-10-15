//
//  ProgressSummaryView.m
//  daytoday
//
//  Created by pasmo on 10/7/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

//#import "ProgressSummaryView.h"
//
//#import "DTProgressElementLayout.h"
//#import "DTDotElement.h"
//
//@interface ProgressSummaryView ()
//- (void)layoutView;
//- (UIView*)layoutSummaryView;
//- (DTProgressElementLayout*)layoutProgressSummary;
//@end
//
//@implementation ProgressSummaryView
//
//static int DAY_WIDTH = 50.0f;
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self layoutView];
//    }
//    return self;
//}
//
//- (void)layoutView
//{
//    DTProgressElementLayout *progress = [self layoutProgressSummary];
//    UIView *labelView = [self layoutSummaryView];
//    
//    labelView.frame = CGRectMake(labelView.frame.origin.x, progress.frame.size.height + 3.0f, labelView.frame.size.height, labelView.frame.size.height);
//    
//    
//    UIView *finalSummaryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, progress.frame.size.height+labelView.frame.size.height)];
//                                
//    [finalSummaryView addSubview:progress];
//    [finalSummaryView addSubview:labelView];
//    
//    [self addSubview:finalSummaryView];
//}
//
//- (DTProgressElementLayout*)layoutProgressSummary
//{
//    DTProgressElementLayout *pSummary = [[DTProgressElementLayout alloc] initWithFrame:CGRectMake(0.0,
//                                                                                                  0.0,
//                                                                                                  self.frame.size.width,
//                                                                                                  DAY_WIDTH) forSummaryWithPercent:0.6f];
//    return pSummary;
//}
//
//- (UIView*)layoutSummaryView
//{
//    //dot with percent number complete
//    //label with percent complete
//    //centered and below the progresselement
//    DTDotElement *percentCircle = [[DTDotElement alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0f, 30.0f)
//                                                        andColorGroup:[DTDotColorGroup currentActiveDayColorGroup]
//                                                            andNumber:[NSNumber numberWithInt:60]];
//    CGSize txtSize = [@"% COMPLETED" sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13] constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    
//    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(percentCircle.frame.size.width + 3.0f,
//                                                                      0.0f,
//                                                                      txtSize.width,
//                                                                      30.0f)];
//    percentLabel.textColor = [UIColor grayColor];
//    percentLabel.backgroundColor = [UIColor clearColor];
//    percentLabel.textAlignment = NSTextAlignmentCenter;
//    percentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
//    percentLabel.text = @"% COMPLETED";
//    
//    CGRect centerFrame = CGRectMake(0.0, 0.0, percentCircle.frame.size.width + 3.0f + percentLabel.frame.size.width, 30.0f);
//    UIView *centeredView = [[UIView alloc] initWithFrame:centerFrame];
//
//    [centeredView addSubview:percentCircle];
//    [centeredView addSubview:percentLabel];
//    
//    [centeredView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
//    return centeredView;
//}
//
//@end
