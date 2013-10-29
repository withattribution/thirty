//
//  ChallengeName.m
//  daytoday
//
//  Created by pasmo on 10/23/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "ChallengeName.h"
#import <QuartzCore/QuartzCore.h>


@interface ChallengeName () {
    NSLayoutConstraint *nameTop;
}

@property (nonatomic, strong) UITextField *textField;
@property (strong, nonatomic) UIView *underline;

@property (copy) void (^completionBlock)();

//TODO make methods to change this view from a disabled looking color scheme to a enabled look one

@end

@implementation ChallengeName

#define DESCRIBE_PLACE_HOLDER  @"Name the challenge"

CGFloat static LINE_HEIGHT = 2.f;
CGFloat static TEXT_PADDING = 10.f;
CGFloat static MARGIN_FACTOR = 0.25f;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _textField = [[UITextField alloc] init];
    [_textField setDelegate:self];
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
    
    _underline = [[UIView alloc] init];
    [_underline setBackgroundColor:[UIColor colorWithWhite:.4f alpha:1.f]];
    [_underline setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_underline];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void) updateConstraints
{

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

  nameTop = [NSLayoutConstraint constraintWithItem:_textField
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.superview
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.f
                                          constant:[[UIScreen mainScreen] applicationFrame].size.height*MARGIN_FACTOR];

  [self.superview addConstraint:nameTop];
  
  [super updateConstraints];

}

#pragma mark - ChallengeName Methods

- (void)namingDidComplete:(void (^)())block
{
  self.completionBlock = [block copy];
}

- (void)shouldBeFirstResponder
{
  if (_textField && ![_textField isFirstResponder]) {
    [_textField becomeFirstResponder];
  }
}

#pragma mark - TextField Delegate Methods 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField.hasText) {
    self.name = [NSString stringWithString:textField.text];
  }
  
  nameTop.constant = [[UIScreen mainScreen] applicationFrame].size.height*(MARGIN_FACTOR-.2f);
  
  [UIView animateWithDuration:0.27F
                   animations:^{
                     [self.superview layoutIfNeeded];
                     [self.superview setAlpha:1.0];

                   }
                   completion:^(BOOL finished) {
                     if (finished && self.completionBlock) {
                       self.isEditing = [NSString stringWithFormat:@"%d",textField.isEditing];
                       self.completionBlock();
                     }
                   }];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  nameTop.constant = [[UIScreen mainScreen] applicationFrame].size.height*(MARGIN_FACTOR);
  self.isEditing = [NSString stringWithFormat:@"%d",textField.isEditing];
  [UIView animateWithDuration:0.4F
                   animations:^{
                     [self.superview layoutIfNeeded];
                   }
                   completion:^(BOOL finished) {
                     if (finished) {
                     }
                   }];
  
  return YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
  if (textField.hasText) {
    self.name = [NSString stringWithString:textField.text];
  }
  return YES;
}


@end
