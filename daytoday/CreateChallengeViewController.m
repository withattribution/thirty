//
//  CreateChallengeViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "CreateChallengeViewController.h"
#import "DTSelectionSheet.h"

#import <UIColor+SR.h>
@interface CreateChallengeViewController ()

@end

@implementation CreateChallengeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = NSLocalizedString(@"Create Challenge", @"create challenge (title)");
  [[DTSelectionSheet selectionSheetWithTitle:@"select duration"] performSelector:@selector(showInView:) withObject:self.view afterDelay:2.0];
}



@end
