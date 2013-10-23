//
//  DescribeChallenge.h
//  daytoday
//
//  Created by pasmo on 8/9/13.
//  Copyright (c) 2013 pasmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescribeChallenge : UIView <UITextViewDelegate> {

}

@property (strong, nonatomic) UITextView *describeText;
@property (nonatomic) NSInteger charCount;
@property (strong, nonatomic) UILabel *charCountLabel;
@property (strong, nonatomic) NSString *challengeDescription;

@end
