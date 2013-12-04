//
//  ChallengeDetailContainer.h
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTViewController.h"

@interface ChallengeDetailContainer : DTViewController

@end

//this is how to delete orphaned files if absolutetly necessary (it is)
//delete orphaned file on parse backend
//curl -X DELETE \
//-H "X-Parse-Application-Id: <YOUR_APPLICATION_ID>" \
//-H "X-Parse-Master-Key: <YOUR_MASTER_KEY>" \
//https://api.parse.com/1/files/<FILE_NAME>