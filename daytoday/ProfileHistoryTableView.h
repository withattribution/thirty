//
//  ProfileHistoryTableView.h
//  daytoday
//
//  Created by pasmo on 10/10/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHistoryTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSArray *intents;

@end
