//
//  DTVerificationCell.h
//  daytoday
//
//  Created by pasmo on 12/18/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTBaseCommentCell.h"
#import "Verification.h"

@interface DTVerificationCell : DTBaseCommentCell

@property (nonatomic) DTVerificationType verificationType;
@property (nonatomic,strong) UIImageView *verificationTypeImage;
@property (nonatomic,strong) UILabel *verificationLabel;

- (void)setOrdinal:(NSNumber *)verificationOrdinal;

+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset;

#define verificationImageDim 25.f

@end
