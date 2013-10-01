//
//  SearchChallengesViewController.m
//  daytoday
//
//  Created by Anderson Miller on 10/1/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "SearchChallengesViewController.h"
#import <UIColor+SR.h>

@interface SearchChallengesViewController ()

@end

@implementation SearchChallengesViewController

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
    self.title = NSLocalizedString(@"Search Challenges", @"search challenges (title)");

	// Do any additional setup after loading the view.
}


@end
