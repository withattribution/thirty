//
//  DescribeChallenge.m
//  daytoday
//
//  Created by pasmo on 8/9/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DescribeChallenge.h"

#define DESCRIBE_PLACE_HOLDER  @"Let's describe this challenge shall we?"

@implementation DescribeChallenge
@synthesize describeText, charCount, charCountLabel, challengeDescription;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.describeText = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 300.0f, 150.0f)];
        [self.describeText setDelegate:self];
        self.describeText.textColor = [UIColor lightGrayColor];
        self.describeText.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        self.describeText.backgroundColor = [UIColor whiteColor];
        [[self.describeText layer] setBorderWidth:2.0f];

        self.describeText.text = DESCRIBE_PLACE_HOLDER;
        
        self.describeText.returnKeyType = UIReturnKeyDefault;
        self.describeText.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
        self.describeText.scrollEnabled = NO;
        
        self.charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0f,180.0f,150.0f,50.0f)];
        self.charCountLabel.textColor = [UIColor whiteColor];
        self.charCountLabel.backgroundColor = [UIColor clearColor];
        self.charCountLabel.textAlignment = NSTextAlignmentLeft;
        self.charCountLabel.font = [UIFont systemFontOfSize:16.0f];
        
        //initialize to zero
        self.charCount = 0;
        
        self.charCountLabel.text = [NSString stringWithFormat:@"%d",self.charCount];
        [self.charCountLabel setHidden:YES];

        [self addSubview:self.charCountLabel];
        [self addSubview:self.describeText];
    }
    return self;
}

- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)saveAction:(UIButton *)sender
{
	// finish typing text/dismiss the keyboard by removing it as the first responder
    if (self.charCount <= 140) {
        self.challengeDescription = [NSString stringWithFormat:@"%@",self.describeText.text];
        [self.describeText resignFirstResponder];
        [sender setHidden:YES];
        sender = nil;
    }else {
        //you have to reject this and tell the user why -- just use the "shake the textview method"
        [self shakeView:self.describeText];
    }
}

- (void) cancel:(UIButton *)sender
{
    [self.describeText resignFirstResponder];
    [sender setHidden:YES];
    sender = nil;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.hasText) {
        self.charCount = [textView.text length];
        self.charCountLabel.text = [NSString stringWithFormat:@"%d",self.charCount];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{       
    if([textView.text isEqualToString:DESCRIBE_PLACE_HOLDER])
        textView.text = @"";
    
    [self.charCountLabel setHidden:NO];
    
    UIButton *cancelDesc = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelDesc setFrame:CGRectMake(10.0f, 180.0f, 90.0f, 50.0f)];
    [cancelDesc addTarget:self
                      action:@selector(cancel:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [cancelDesc setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self addSubview:cancelDesc];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setFrame:CGRectMake(250.0f, 180.0f, 70.0f, 50.0f)];
    [dismissButton addTarget:self
                      action:@selector(saveAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [dismissButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self addSubview:dismissButton];
}

@end
