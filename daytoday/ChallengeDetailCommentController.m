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

//@property (nonatomic,strong) FDTakeController *takeController;

@property (nonatomic,strong) PFFile *commentImageFile;
@property (nonatomic,strong) PFFile *commentThumbnailFile;
@property (nonatomic,assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic,assign) UIBackgroundTaskIdentifier imagePostBackgroundTaskId;

@property (nonatomic,strong) NSString *challengeDayId;

@property (nonatomic,assign) BOOL isTakingPhoto;

@end

@implementation ChallengeDetailCommentController

- (void)dealloc
{

}

- (id)initWithChallengeDayID:(NSString *)dayId
{
    self = [super init];
    if (self) {
      _challengeDayId = dayId;

//      self.parseClassName = kDTChallengeDayClassKey;
      
      self.isTakingPhoto = NO;
      [self.view setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}

#pragma mark - Table View Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//  if (self.intents && [self.intents count] > 0)
//    return [self.intents count];
//  else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//  if([((Intent *)[self.intents objectAtIndex:section]) daysLeft] > 0)
//    return 3;
//  else
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.f;
}

#pragma mark - PFQueryTableViewController

//- (PFQuery *)queryForTable {
//  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
////  [query whereKey:kDTActivityTypeComment equalTo:kDTActivityTypeKey];
//  
//  [query includeKey:kDTActivityClassKey];
////  [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeComment];
////  [query orderByAscending:@"createdAt"];
////  
//  [query setCachePolicy:kPFCachePolicyNetworkOnly];
//  
//  // If no objects are loaded in memory, we look to the cache first to fill the table
//  // and then subsequently do a query against the network.
//  //
//  // If there is no network connection, we will hit the cache first.
////  if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
////    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
////  }
//  
//  return query;
//}

//- (void)objectsDidLoad:(NSError *)error
//{
//  [super objectsDidLoad:error];
//  NIDINFO(@"object count: %d",[self.objects count]);
//  
//  id d = [self.objects firstObject];
//  
//  for (NSString *k in [d allKeys]) {
//    NIDINFO(@"the key: %@ and the object: %@",k,[d objectForKey:k]);
//  }
//}
//  if (NSClassFromString(@"UIRefreshControl")) {
//    [self.refreshControl endRefreshing];
//  }
//  
//  [self.headerView reloadLikeBar];
//  [self loadLikers];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
//{
//  static NSString *cellID = @"CommentCell";
//  
//  // Try to dequeue a cell and create one if necessary
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
////    cell.cellInsetWidth = kPAPCellInsetWidth;
////    cell.delegate = self;
//    cell.backgroundColor = [UIColor randomColor];
//  }
//  
////  [cell setUser:[object objectForKey:kPAPActivityFromUserKey]];
////  [cell setContentText:[object objectForKey:kPAPActivityContentKey]];
////  [cell setDate:[object createdAt]];
//  
//  return cell;
//}

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
  NIDINFO(@"<><><><> VIEW IS ABOUT TO DISAPPEAR! <><><><>");
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

//delete orphaned file on parse backend
//curl -X DELETE \
//-H "X-Parse-Application-Id: <YOUR_APPLICATION_ID>" \
//-H "X-Parse-Master-Key: <YOUR_MASTER_KEY>" \
//https://api.parse.com/1/files/<FILE_NAME>



@end
