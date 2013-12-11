//
//  DTImageView.m
//  daytoday
//
//  Created by pasmo on 12/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTImageView.h"

@interface DTImageView ()

@property (nonatomic,strong) PFFile *currentFile;
@property (nonatomic,strong) NSString *url;

@end


@implementation DTImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
