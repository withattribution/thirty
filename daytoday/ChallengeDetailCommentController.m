//
//  ChallengeDetailCommentController.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDetailCommentController.h"


#import "UIImage+Resizing.h"
#import "UIColor+SR.h"

@interface ChallengeDetailCommentController ()

@property (nonatomic,strong) PFObject *challengeDay;

@end

@implementation ChallengeDetailCommentController

- (id)initWithChallengeDay:(PFObject *)chDay
{
    self = [super init];
    if (self) {
      self.challengeDay= chDay;
      self.parseClassName = kDTActivityClassKey;
      self.pullToRefreshEnabled = NO;
      [self.view setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}

#pragma mark - Table View Datasource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////  if (self.intents && [self.intents count] > 0)
////    return [self.intents count];
////  else
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////  if([((Intent *)[self.intents objectAtIndex:section]) daysLeft] > 0)
////    return 3;
////  else
//    return 20;
//}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.f;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:kDTActivityClassKey];
  [query whereKey:kDTActivityChallengeDayKey
          equalTo:[PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:self.challengeDay.objectId]];
  [query setCachePolicy:kPFCachePolicyNetworkOnly];
// If no objects are loaded in memory, we look to the cache first to fill the table
// and then subsequently do a query against the network.
//
// If there is no network connection, we will hit the cache first.
//  if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
//    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//  }
  return query;
}

- (void)objectsDidLoad:(NSError *)error
{
  [super objectsDidLoad:error];
  NIDINFO(@"object count: %d",[self.objects count]);
  
  [[DTCache sharedCache] refreshCacheActivity:self.objects forChallengeDay:self.challengeDay];

//  for (NSString *k in [d allKeys]) {
//    NIDINFO(@"the key: %@ and the object: %@",k,[d objectForKey:k]);
//  }
//  if (NSClassFromString(@"UIRefreshControl")) {
//    [self.refreshControl endRefreshing];
//  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
  static NSString *cellID = @"CommentCell";
  
  // Try to dequeue a cell and create one if necessary
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    cell.cellInsetWidth = kPAPCellInsetWidth;
//    cell.delegate = self;
    cell.backgroundColor = [UIColor randomColor];
  }
  
  cell.textLabel.text = [object objectForKey:kDTActivityContentKey];
  
//  [cell setUser:[object objectForKey:kPAPActivityFromUserKey]];
//  [cell setContentText:[object objectForKey:kPAPActivityContentKey]];
//  [cell setDate:[object createdAt]];
  
  return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//  static NSString *CellIdentifier = @"NextPage";
//  
//  PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//  
//  if (cell == nil) {
//    cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    cell.cellInsetWidth = kPAPCellInsetWidth;
//    cell.hideSeparatorTop = YES;
//  }
//  
//  return cell;
//}

#pragma mark - UIViewController Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}





@end
