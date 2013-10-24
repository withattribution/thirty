//
//  ChallengeName.m
//  daytoday
//
//  Created by pasmo on 10/23/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeName.h"
#import <QuartzCore/QuartzCore.h>


@interface ChallengeName ()

@property (strong, nonatomic) UIView *underline;

@end

@implementation ChallengeName

#define DESCRIBE_PLACE_HOLDER  @"Name the challenge"

CGFloat static LINE_HEIGHT = 2.f;
CGFloat static TEXT_PADDING = 10.f;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    _textField = [[UITextField alloc] init];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [_textField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:.4f]];
    [_textField setTextAlignment:NSTextAlignmentCenter];
    [_textField setReturnKeyType:UIReturnKeyDefault];
    [_textField setKeyboardType:UIKeyboardTypeDefault];
    [_textField setPlaceholder:DESCRIBE_PLACE_HOLDER];
    [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_textField sizeToFit];
    
    [self addSubview:_textField];

//    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 320., 50.f)];
//    [toolBarView setBackgroundColor:[UIColor redColor]];
//    [_textField setInputAccessoryView:toolBarView];
    
    _underline = [[UIView alloc] init];
    [_underline setBackgroundColor:[UIColor colorWithWhite:.4f alpha:1.f]];
    [_underline setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_underline];
  }
  return self;
}

- (void) updateConstraints
{

  [super updateConstraints];

  NSDictionary *metrics = @{@"textFieldHeight":@(_textField.frame.size.height+TEXT_PADDING),@"lineHeight":@(LINE_HEIGHT)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textField": _textField}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[underline]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"underline":_underline}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField(textFieldHeight)][underline(lineHeight)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textField": _textField,@"underline":_underline}]];
}

@end
