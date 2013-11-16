//
//  DTSocialDashBoard.m
//  daytoday
//
//  Created by pasmo on 11/15/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "DTSocialDashBoard.h"

@interface DTSocialDashBoard ()

@property (nonatomic,strong) UIButton *heartButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *shareButton;

@property (nonatomic,assign) NSUInteger *hearts;
@property (nonatomic,assign) NSUInteger *comments;

@end


@implementation DTSocialDashBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
      [_heartButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];

      [_heartButton setImage:[UIImage imageNamed:@"heart-normal.png"] forState:UIControlStateNormal];
      [_heartButton setImage:[UIImage imageNamed:@"heart-selected.png"] forState:UIControlStateSelected];

      [_heartButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      [_heartButton setTitle:@"47" forState:UIControlStateNormal];
      
      [_heartButton setAdjustsImageWhenHighlighted:NO];

      //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)

      [_heartButton setContentEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
      [_heartButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 20.f, 0.f, 5.f)];
      [_heartButton setTitleEdgeInsets:UIEdgeInsetsMake(-16.5f, -10.f, 1.f, -36.f)];

      [_heartButton setFrame:CGRectMake(0.f, 0.f, 105.f, 40.f)];
      [_heartButton addTarget:self.superview action:@selector(heartSelected:) forControlEvents:UIControlEventTouchUpInside];

      [_heartButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
//      [_heartButton setTranslatesAutoresizingMaskIntoConstraints:NO];

      [self addSubview:_heartButton];
      
      _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
      [_commentButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
      
      [_commentButton setImage:[UIImage imageNamed:@"comment-normal.png"]
                      forState:UIControlStateNormal];
      [_commentButton setImage:[UIImage imageNamed:@"comment-selected.png"]
                      forState:UIControlStateSelected];
      [_commentButton setImage:[UIImage imageNamed:@"comment-selected.png"]
                      forState:(UIControlStateSelected | UIControlStateHighlighted)];
      
      [_commentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      [_commentButton setTitle:@"47" forState:UIControlStateNormal];
      
      [_commentButton setAdjustsImageWhenHighlighted:NO];
      
      //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
      
      [_commentButton setContentEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
      [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 20.f, 0.f, 5.f)];
      [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(-16.5f, -10.f, 1.f, -36.f)];
      
      [_commentButton setFrame:CGRectMake(_heartButton.frame.origin.y + _heartButton.frame.size.width + 2.f, 0.f, 105.f, 40.f)];
      [_commentButton addTarget:self action:@selector(commentSelected:) forControlEvents:UIControlEventTouchUpInside];
      
      [_commentButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
//      [_commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_commentButton];
      
//      NSLog(@"comment frame: %@", CGRectCreateDictionaryRepresentation(_commentButton.frame));
      
      _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
      [_shareButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
      [_shareButton.titleLabel setNumberOfLines:2];
      [_shareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
      
//      [_shareButton setImage:[UIImage imageNamed:@"comment-normal.png"] forState:UIControlStateNormal];
      [_shareButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [_shareButton setTitle:@"share    disabled" forState:UIControlStateNormal];
      
      [_shareButton setAdjustsImageWhenHighlighted:NO];
      
      //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
      
//      [_shareButton setContentEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
//      [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 20.f, 0.f, 5.f)];
//      [_shareButton setTitleEdgeInsets:UIEdgeInsetsMake(-16.5f, -10.f, 1.f, -36.f)];
      
      [_shareButton setFrame:CGRectMake(_heartButton.frame.origin.y + _heartButton.frame.size.width + _commentButton.frame.origin.y + _commentButton.frame.size.width + 2.f + 2.f, 0.f, 105.f, 40.f)];
      [_shareButton addTarget:self action:@selector(shareSelected:) forControlEvents:UIControlEventTouchUpInside];
      
      [_shareButton setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
//      [_shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
      
      [self addSubview:_shareButton];
      
      //  NSLog(@"share frame: %@", CGRectCreateDictionaryRepresentation(_shareButton.frame));
    }
    return self;
}

- (void)heartSelected:(UIButton *)heart
{
  NSLog(@"this is the heart state: %d",self.heartButton.state);
  
  if (self.heartButton.state == (UIControlStateHighlighted | UIControlStateSelected) ) {
    [self.heartButton setSelected:NO];
    NSLog(@"this is the heart not selected state: %d",self.heartButton.state);
  }
  else {
    [self.heartButton setSelected:YES];
    [self.heartButton setHighlighted:NO];

    NSLog(@"this is the heart is selected state: %d",self.heartButton.state);
  }
  
  //increment the count as well
  
}

- (void)commentSelected:(UIButton *)comment
{
  NSLog(@"this is the comment state: %d",self.commentButton.state);
  
  if ([_delegate respondsToSelector:@selector(didSelectComments)])
    [_delegate didSelectComments];
  
  if (self.commentButton.state == UIControlStateHighlighted ) {
    NSLog(@"i am selected now");
    [self.commentButton setSelected:YES];
  }
  
  //increment the count as well

}

- (void)shareSelected:(UIButton *)share
{
  NSLog(@"this is the share");
}

- (void)resetCommentDisplayState
{
  if (self.commentButton) {
    [self.commentButton setSelected:NO];
    [self.commentButton setHighlighted:NO];
    
    //decrement the count as well

  }
}


@end