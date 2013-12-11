//
//  CommentCell.m
//  daytoday
//
//  Created by pasmo on 12/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "CommentCell.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface CommentCell (){
  BOOL hasContentImage;
  BOOL hasContentText;
}

+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    hasContentText = NO;
    hasContentImage = NO;

    if (!timeFormatter) {
      timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }

    self.cellInsetWidth = 0;
    horizontalTextSpace =  [CommentCell horizontalTextSpaceForInsetWidth:self.cellInsetWidth];

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
    ////    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.userImageView];

    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameButton setBackgroundColor:[UIColor clearColor]];
    [self.nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nameButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.nameButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
    [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    //    [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //    [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
    [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.nameButton];

    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    [self.timeLabel setTextColor:[UIColor blackColor]];
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
//    [self.timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.70f]];
//    [self.timeLabel setShadowOffset:CGSizeMake(0, 1)];
    [self.mainView addSubview:self.timeLabel];

    self.contentLabel = [[UILabel alloc] init];
    [self.contentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    [self.contentLabel setNumberOfLines:0];
    [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:self.contentLabel];
    
    self.contentImageView = [[PFImageView alloc] init];
    [self.contentImageView setBackgroundColor:[UIColor clearColor]];
    [self.contentImageView setOpaque:YES];
    [self.mainView addSubview:self.contentImageView];

//    self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.userButton setBackgroundColor:[UIColor clearColor]];
//    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.mainView addSubview:self.userButton];

    [self.contentView addSubview:self.mainView];
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
//  [self.userButton setFrame:CGRectMake(userImageX, userImageY, userImageDim, userImageDim)];

  // Layout the name button
  CGRect nameRect = [@"username" boundingRectWithSize:CGSizeMake(nameMaxWidth,CGFLOAT_MAX)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]}
                                                                        context:nil];
  [self.nameButton setFrame:CGRectMake(nameX, nameY, nameRect.size.width, nameRect.size.height)];

  // Layout the contentText
  CGRect textContentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace,CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13]}
                                                            context:nil];
  
  CGFloat textContentY = vertBorderSpacing+userImageDim;
  
  if (hasContentImage)
  {
    textContentY += imageContentDim;
    [self.contentImageView setFrame:CGRectMake(0.f, vertBorderSpacing+(userImageDim*(.80f)), imageContentDim-(2*self.cellInsetWidth), imageContentDim)];
  }
  
  [self.contentLabel setFrame:CGRectMake(textContentX, textContentY, textContentRect.size.width, textContentRect.size.height)];

  

  // Layout the timestamp label
  CGRect timeRect = [self.timeLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace,CGFLOAT_MAX)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                                     context:nil];
  
  [self.timeLabel setFrame:CGRectMake(self.mainView.frame.size.width-timeRect.size.width, timeY, timeRect.size.width, timeRect.size.height)];
  [self.mainView bringSubviewToFront:self.userImageView];
}

/*! Static Helper methods */
+ (CGFloat)heightForCellTextContent:(NSString *)textContent
                        imageOjbect:(PFObject *)imageObject
                     cellInsetWidth:(CGFloat)cellInset
{
  CGFloat interpretedHorizontalTextSpace =  [CommentCell horizontalTextSpaceForInsetWidth:cellInset];
  
  CGRect textContentRect = [textContent boundingRectWithSize:CGSizeMake(interpretedHorizontalTextSpace,CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
                                                     context:nil];

//  CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:13.0f] forWidth:200.0f lineBreakMode:NSLineBreakByTruncatingTail];
//  NSString *paddedString = [PAPBaseTextCell padString:content withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
//  CGFloat horizontalTextSpace = [PAPActivityCell horizontalTextSpaceForInsetWidth:cellInset];
//  
//  CGSize contentSize = [paddedString sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//  CGFloat singleLineHeight = [@"Test" sizeWithFont:[UIFont systemFontOfSize:13.0f]].height;
  
// Calculate the added height necessary for multiline text. Ensure value is not below 0.
//  CGFloat multilineHeightAddition = contentSize.height - singleLineHeight;

  CGFloat imageHeight = 0.f;

  if (imageObject) {
    imageHeight += imageContentDim;
  }

  return vertBorderSpacing+userImageDim+(4*vertElemSpacing) + textContentRect.size.height + imageHeight;//48.0f + fmax(0.0f, multilineHeightAddition);
}

#pragma mark - Delegate methods
///* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
    [self.delegate cell:self didTapUserButton:self.user];
  }
}

- (void)setUser:(PFUser *)aUser {
  _user = aUser;
  // Set name button properties and avatar image
//  [self.userImageView setFile:[_user objectForKey:kPAPUserProfilePicSmallKey]];
  [self.nameButton setTitle:@"username" forState:UIControlStateNormal];
  [self.nameButton setTitle:@"username" forState:UIControlStateHighlighted];
  
  // If user is set after the contentText, we reset the content to include padding
  if (self.contentLabel.text) {
    [self setContentText:self.contentLabel.text];
  }
  [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString {
  if (contentString != nil) {
    hasContentText = YES;
  }
  
  // If we have a user we pad the content with spaces to make room for the name
//  if (self.user) {
//    CGSize nameSize = [self.nameButton.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13] forWidth:nameMaxWidth lineBreakMode:NSLineBreakByTruncatingTail];
//    CGRect nameRect = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth,CGFLOAT_MAX)
//                                                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]}
//                                                                    context:nil];
//    NSString *paddedString = [PAPBaseTextCell padString:contentString withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
//    [self.contentLabel setText:paddedString];
//  } else { // Otherwise we ignore the padding and we'll add it after we set the user
    [self.contentLabel setText:contentString];
//  }
  [self setNeedsDisplay];
}

- (void)setContentImage:(PFObject *)imageObject
{
  if (!imageObject) {
    return;
  }

  hasContentImage = YES;

  self.contentImageView.image = [UIImage imageNamed:@"commentImagePlaceholder.jpg"];

  [imageObject fetchIfNeededInBackgroundWithBlock:^(PFObject *imgObj, NSError *error){
    [self.contentImageView setFile:[imgObj objectForKey:kDTImageMediumKey]];
    [self.contentImageView loadInBackground];
    [self setNeedsDisplay];
  }];
}

- (void)setDate:(NSDate *)date {
  // Set the label with a human readable time
  [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
  [self setNeedsDisplay];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
  // Change the mainView's frame to be insetted by insetWidth and update the content text space
  _cellInsetWidth = insetWidth;
  [self.mainView setFrame:CGRectMake(insetWidth, self.mainView.frame.origin.y, self.mainView.frame.size.width-2*insetWidth, self.mainView.frame.size.height)];
  horizontalTextSpace = [CommentCell horizontalTextSpaceForInsetWidth:insetWidth];
  [self setNeedsDisplay];
}

/* Static helper to obtain the  horizontal space left for name and content after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
  return (320-(insetWidth*2)) - (horiBorderSpacing+userImageDim+horiElemSpacing+horiBorderSpacing);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
