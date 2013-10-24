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

}

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
    
    _nameField = [[UITextField alloc] init];
    [_nameField setTextColor:[UIColor whiteColor]];
    [_nameField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [_nameField setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.f]];
    [_nameField setTextAlignment:NSTextAlignmentCenter];
    [_nameField setReturnKeyType:UIReturnKeyDefault];
    [_nameField setKeyboardType:UIKeyboardTypeDefault];
//    [_nameField setScrollEnabled:NO];
//    [_nameField becomeFirstResponder];
    [_nameField setPlaceholder:DESCRIBE_PLACE_HOLDER];
    [_nameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_nameField sizeToFit];
    
    [self addSubview:_nameField];
//    [_nameField setDelegate:self.superview];

//    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 320., 50.f)];
//    [toolBarView setBackgroundColor:[UIColor redColor]];
//    [_nameField setInputAccessoryView:toolBarView];
    
    
    _underline = [[UIView alloc] init];
    [_underline setBackgroundColor:[UIColor colorWithWhite:.2f alpha:1.f]];
    [_underline setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_underline];
  }
  return self;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//  NSLog(@"touchesBegan:withEvent:");
//  [self endEditing:YES];
//  [super touchesBegan:touches withEvent:event];
//}


- (void) updateConstraints
{

  NSDictionary *metrics = @{@"textFieldHeight":@(_nameField.frame.size.height+TEXT_PADDING),@"lineHeight":@(LINE_HEIGHT)};
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameField]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"nameField": _nameField}]];

  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[underline]|"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"underline":_underline}]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameField(textFieldHeight)][underline(lineHeight)]"
                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                               metrics:metrics
                                                                 views:@{@"nameField": _nameField,@"underline":_underline}]];
  [super updateConstraints];  
}




#pragma mark -
#pragma mark UITextViewDelegate

- (void)saveAction:(UIButton *)sender
{
//	// finish typing text/dismiss the keyboard by removing it as the first responder
//  if (self.charCount <= 140) {
//    self.challengeDescription = [NSString stringWithFormat:@"%@",self.describeText.text];
//    [self.nameField resignFirstResponder];
//    [sender setHidden:YES];
//    sender = nil;
//  }else {
//    //you have to reject this and tell the user why -- just use the "shake the textview method"
//    [self shakeView:self.describeText];
//  }
}

- (void) cancel:(UIButton *)sender
{
  [_nameField resignFirstResponder];
  [sender setHidden:YES];
  sender = nil;
}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//  NSLog(@"textViewShouldEndEditing:");
//  textView.backgroundColor = [UIColor whiteColor];
//  return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if([text isEqualToString:@"\n"]) {
//    [textView resignFirstResponder];
    
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
//                                                           attribute:NSLayoutAttributeHeight
//                                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                              toItem:_nameField
//                                                           attribute:NSLayoutAttributeHeight
//                                                          multiplier:1.f
//                                                            constant:60]];
    
//    [self setNeedsUpdateConstraints]; // Ensures that all pending layout operations have been completed
//    [UIView animateWithDuration:1.0 animations:^{
//      // Make all constraint changes here
//      _textFieldHeight.constant *= 2.f;
//      [self layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
//    }];

//    NSLog(@"new constraints :%f",_textFieldHeight.constant);
//    [self updateConstraintsIfNeeded];
    return NO;
  }
  return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if([textView.text isEqualToString:DESCRIBE_PLACE_HOLDER]) textView.text = @"";

  
//  UIButton *cancelDesc = [UIButton buttonWithType:UIButtonTypeCustom];
//  [cancelDesc setFrame:CGRectMake(10.0f, 180.0f, 90.0f, 50.0f)];
//  [cancelDesc addTarget:self
//                 action:@selector(cancel:)
//       forControlEvents:UIControlEventTouchUpInside];
//  
//  [cancelDesc setTitle:@"CANCEL" forState:UIControlStateNormal];
//  [self addSubview:cancelDesc];
//  
//  UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
//  [dismissButton setFrame:CGRectMake(250.0f, 180.0f, 70.0f, 50.0f)];
//  [dismissButton addTarget:self
//                    action:@selector(saveAction:)
//          forControlEvents:UIControlEventTouchUpInside];
//  
//  [dismissButton setTitle:@"SAVE" forState:UIControlStateNormal];
//  [self addSubview:dismissButton];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  NSLog(@"return button pressed");
}


@end
