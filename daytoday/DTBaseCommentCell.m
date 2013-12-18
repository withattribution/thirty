//
//  DTBaseCommentCell.m
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTBaseCommentCell.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface DTBaseCommentCell ()
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;
@end

@implementation DTBaseCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
      }
      
      self.cellInsetWidth = 0;
      horizontalTextSpace =  [DTBaseCommentCell horizontalTextSpaceForInsetWidth:self.cellInsetWidth];
      
      self.opaque = YES;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.accessoryType = UITableViewCellAccessoryNone;
      self.backgroundColor = [UIColor clearColor];
      
      self.mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
      [self.mainView setBackgroundColor:[UIColor clearColor]];
      
      self.userImageView = [[DTProfileImageView alloc] init];
      [self.userImageView.layer setCornerRadius:userImageDim/2.f];
      [self.userImageView setBackgroundColor:[UIColor darkGrayColor]];
      [self.userImageView setOpaque:YES];
      [self.userImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.userImageView];
      
      self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.nameButton setBackgroundColor:[UIColor clearColor]];
      [self.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [self.nameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
      [self.nameButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
      [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
      [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.mainView addSubview:self.nameButton];
      
      self.timeLabel = [[UILabel alloc] init];
      [self.timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
      [self.timeLabel setTextColor:[UIColor blackColor]];
      [self.timeLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.timeLabel];
      
      self.textBacking = [[UIView alloc] init];
      [self.textBacking setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
      [self.mainView addSubview:self.textBacking];
      
      self.contentLabel = [[UILabel alloc] init];
      [self.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
      [self.contentLabel setTextColor:[UIColor darkGrayColor]];
      [self.contentLabel setNumberOfLines:1];
      [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
      [self.contentLabel setBackgroundColor:[UIColor clearColor]];
      [self.mainView addSubview:self.contentLabel];
      
      self.contentImageView = [[PFImageView alloc] init];
      [self.contentImageView setBackgroundColor:[UIColor clearColor]];
      [self.contentImageView setOpaque:YES];
      [self.mainView addSubview:self.contentImageView];
      
      [self addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self.mainView setFrame:CGRectMake(self.cellInsetWidth,
                                     self.contentView.frame.origin.y,
                                     self.contentView.frame.size.width - (2*self.cellInsetWidth),
                                     self.contentView.frame.size.height)];
  // Layout user image
  [self.userImageView setFrame:CGRectMake(userImageX, userImageY, userImageDim, userImageDim)];
  // Layout the name button
  CGRect nameRect = [@"username" boundingRectWithSize:CGSizeMake(nameMaxWidth,CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]}
                                              context:nil];
  [self.nameButton setFrame:CGRectMake(nameX, nameY, nameRect.size.width, nameRect.size.height)];
  // Layout the timestamp label
  CGRect timeRect = [self.timeLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace,CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                      context:nil];
  [self.timeLabel setFrame:CGRectMake(self.mainView.frame.size.width-timeRect.size.width, timeY, timeRect.size.width, timeRect.size.height)];
  
  CGFloat textBackingY = self.userImageView.frame.origin.y+userImageDim*.80;
  
  if (self.contentImageView.image != nil)
  {
    textBackingY += imageContentDim+vertElemSpacing;
    [self.contentImageView setFrame:CGRectMake(0.f,
                                               self.userImageView.frame.origin.y+userImageDim*.80,
                                               imageContentDim-(2*self.cellInsetWidth),
                                               imageContentDim)];
  }
  
  // Layout the contentText
  CGRect textContentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.mainView.frame.size.width-(2*textContentX),CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                                context:nil];

  [self.textBacking setFrame:CGRectMake(0.f,
                                        textBackingY,
                                        self.mainView.frame.size.width,
                                        (2*vertBorderSpacing)+textContentRect.size.height+(2*vertElemSpacing))];

  [self.contentLabel setFrame:CGRectMake(textContentX, textBackingY+vertBorderSpacing+vertElemSpacing, textContentRect.size.width, textContentRect.size.height)];
  [self.mainView bringSubviewToFront:self.userImageView];
}

#pragma Static Helper Methods
/* Static helper to obtain the  horizontal space left for time after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
  return ([[UIScreen mainScreen] bounds].size.width-(insetWidth*2) - (userImageX+horiElemSpacing+userImageDim));
}

/*! Static Helper methods */
+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset
{
  CGRect textContentRect = [textContent boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-(cellInset*2)-(2*textContentX),CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                     context:nil];
  CGFloat imageHeight = 0.f;
  if (imageContent) {
    imageHeight += imageContentDim;
  }
  return vertBorderSpacing+userImageDim+textContentRect.size.height+vertElemSpacing+vertElemSpacing+vertBorderSpacing+imageHeight;
}

#pragma mark - Setter Methods

- (void)setCellInsetWidth:(CGFloat)insetWidth
{
  // Change the mainView's frame to be insetted by insetWidth and update the content text space
  _cellInsetWidth = insetWidth;
  [self.mainView setFrame:CGRectMake(insetWidth, self.mainView.frame.origin.y, self.mainView.frame.size.width-2*insetWidth, self.mainView.frame.size.height)];
  horizontalTextSpace = [DTBaseCommentCell horizontalTextSpaceForInsetWidth:insetWidth];
  [self setNeedsDisplay];
}

- (void)setDate:(NSDate *)date
{
  // Set the label with a human readable time
  [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
  [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString
{
  [self.contentLabel setText:contentString];
  [self setNeedsDisplay];
}

- (void)setUser:(PFUser *)aUser {
  _user = aUser;
  // Set name button properties and avatar image
  //  [self.userImageView setFile:[_user objectForKey:kPAPUserProfilePicSmallKey]];
  [self.nameButton setTitle:@"username" forState:UIControlStateNormal];
  [self.nameButton setTitle:@"username" forState:UIControlStateHighlighted];
  
  [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

# pragma mark - Reuse Method

- (void) prepareForReuse
{
  [super prepareForReuse];
  
  self.contentImageView.image = nil;
  self.contentImageView.file = nil;
}


#pragma mark - Base Delegate method
///* Inform delegate that a user image or name button was tapped */
- (void)didTapUserButtonAction:(id)sender {
  
  NIDINFO(@"yes you did");
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
    [self.delegate cell:self didTapUserButton:self.user];
  }
}

@end
