//
//  ProfileViewController.h
//  daytoday
//
//  Created by Alberto Tafoya on 12/2/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "DTViewController.h"

@interface ProfileViewController : DTViewController
{

}

@property (nonatomic,strong) PFUser *aUser;

- (id)initWithUser:(PFUser *)user;

@end
