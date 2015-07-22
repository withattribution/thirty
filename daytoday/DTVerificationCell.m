//
//  DTVerificationCell.m
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTVerificationCell.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface DTVerificationCell ()
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;
@end

@implementation DTVerificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    if (!timeFormatter) {
      timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }

    self.cellInsetWidth = 0;
    horizontalTextSpace =  [DTVerificationCell horizontalTextSpaceForInsetWidth:self.cellInsetWidth];
    
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.verificationTypeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verificationTick.png"]];
    [self.verificationTypeImage setBackgroundColor:[UIColor clearColor]];
    [self.verificationTypeImage setOpaque:YES];
    [self.mainView addSubview:self.verificationTypeImage];
    
    self.verificationLabel = [[UILabel alloc] init];
    [self.verificationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [self.verificationLabel setTextColor:[UIColor darkGrayColor]];
    [self.verificationLabel setNumberOfLines:1];
    [self.verificationLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.verificationLabel setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:self.verificationLabel];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  CGFloat textBackingY = self.userImageView.frame.origin.y+userImageDim*.80;
  
  if (self.contentImageView.image != nil)
  {
    textBackingY += imageContentDim+vertElemSpacing;
    [self.contentImageView setFrame:CGRectMake(0.f,
                                               self.userImageView.frame.origin.y+userImageDim*.80,
                                               imageContentDim-(2*self.cellInsetWidth),
                                               imageContentDim)];
  }
  CGRect verificationTextRect = [self.verificationLabel.text boundingRectWithSize:CGSizeMake(self.mainView.frame.size.width-(2*textContentX),CGFLOAT_MAX)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                                          context:nil];
  
  CGRect textContentRect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.mainView.frame.size.width-(2*textContentX),CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15]}
                                                                context:nil];
  [self.textBacking setFrame:CGRectMake(0.f,
                                        textBackingY,
                                        self.mainView.frame.size.width,
                                        (2*vertBorderSpacing)+verificationImageDim+textContentRect.size.height+(3*vertElemSpacing))];
  [self.verificationTypeImage setFrame:CGRectMake(self.userImageView.center.x-verificationImageDim/2.f,
                                                  textBackingY+vertBorderSpacing+vertElemSpacing,
                                                  verificationImageDim,
                                                  verificationImageDim)];
  [self.verificationLabel setFrame:CGRectMake(nameX,
                                              textBackingY+vertBorderSpacing+vertElemSpacing+(verificationImageDim-verificationTextRect.size.height)/2.f,
                                              verificationTextRect.size.width,
                                              verificationTextRect.size.height)];
  [self.contentLabel setFrame:CGRectMake(textContentX, textBackingY+vertBorderSpacing+verificationImageDim+(2*vertElemSpacing), textContentRect.size.width, textContentRect.size.height)];
  
  [self.mainView bringSubviewToFront:self.userImageView];
}

#pragma Static Helper Methods
/* Static helper to obtain the  horizontal space left for time after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth
{
  return [[self superclass] horizontalTextSpaceForInsetWidth:insetWidth];
}

+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset
{
  return [[self superclass] heightForCellTextContent:textContent hasImageContent:imageContent cellInsetWidth:cellInset]+vertElemSpacing+verificationImageDim;
}

#pragma mark Setter Methods

- (void)setOrdinal:(NSNumber *)verificationOrdinal
{
  [self.verificationLabel setText:[[NSString stringWithFormat:@"%@ %@ OF THE DAY",
                               [Verification ordinalMessageForNumber:verificationOrdinal],
                               [Verification stringForType:(DTVerificationType)0]] uppercaseString]];
  [self setNeedsDisplay];
}

- (void)setVerificationType:(DTVerificationType)verificationType
{
  [self.verificationTypeImage setImage:[Verification activityImageForType:verificationType]];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth
{
  [super setCellInsetWidth:insetWidth];
  // Change the mainView's frame to be insetted by insetWidth and update the content text space
  horizontalTextSpace = [DTVerificationCell horizontalTextSpaceForInsetWidth:insetWidth];
  [self setNeedsDisplay];
}

@end
