//
//  ChallengeDescription.m
//  daytoday
//
//  Created by pasmo on 10/24/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeDescription.h"

@interface ChallengeDescription () {
  NSLayoutConstraint *descriptionTop;
}

@property (strong, nonatomic) UITextView *textView;
@property (nonatomic) NSInteger charCount;
@property (strong, nonatomic) UILabel *charCountLabel;
@property (strong, nonatomic) NSString *challengeDescription;

@end

@implementation ChallengeDescription

#define DESCRIBE_PLACE_HOLDER  @"Let's describe this challenge shall we?"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _textView = [[UITextView alloc] init];
      [_textView setDelegate:self];
      [_textView setTextColor:[UIColor whiteColor]];
      [_textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0] ];
      [_textView setBackgroundColor:[UIColor colorWithWhite:.8f alpha:.4f]];

      [[_textView layer] setBorderWidth:2.0f];
      
      [_textView setText:DESCRIBE_PLACE_HOLDER];

      [_textView setReturnKeyType:UIReturnKeyDefault];
      [_textView setKeyboardType:UIKeyboardTypeDefault];
      
      [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
      [_textView setScrollEnabled:NO];
      
      [self addSubview:_textView];

//      self.charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0f,180.0f,150.0f,50.0f)];
//      self.charCountLabel.textColor = [UIColor whiteColor];
//      self.charCountLabel.backgroundColor = [UIColor clearColor];
//      self.charCountLabel.textAlignment = NSTextAlignmentLeft;
//      self.charCountLabel.font = [UIFont systemFontOfSize:16.0f];
//      
//      //initialize to zero
//      self.charCount = 0;
//      
//      self.charCountLabel.text = [NSString stringWithFormat:@"%d",self.charCount];
//      [self.charCountLabel setHidden:YES];
//      
//      [self addSubview:self.charCountLabel];
    }
    return self;
}

- (void)updateConstraints
{
  [super updateConstraints];
  
  NSDictionary *metrics = @{@"textViewHeight":@(150)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textView": _textView}]];
  
//  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[underline]|"
//                                                               options:NSLayoutFormatDirectionLeadingToTrailing
//                                                               metrics:metrics
//                                                                 views:@{@"underline":_underline}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(textViewHeight)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"textView": _textView}]];
  
  [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.f
                                                              constant:0]];
  
  descriptionTop = [NSLayoutConstraint constraintWithItem:self
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.superview
                                                attribute:NSLayoutAttributeTop
                                               multiplier:1.f
                                                 constant:self.superview.frame.size.height*.20];

  [self.superview addConstraint:descriptionTop];

}

@end
