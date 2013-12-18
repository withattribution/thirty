//
//  ChallengeDayCommentController.m
//  daytoday
//
//  Created by pasmo on 11/14/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import "ChallengeDayCommentController.h"
#import "DTBaseCommentCell.h"
#import "DTVerificationCell.h"

#import "UIImage+Resizing.h"

@interface ChallengeDayCommentController () <DTBaseCommentCellDelegate>

@property (nonatomic,strong) PFObject *challengeDay;

@end

#define kCommentCellInsetWidth 5.f

@implementation ChallengeDayCommentController

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


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable
{
  PFQuery *commentActivity = [PFQuery queryWithClassName:kDTActivityClassKey];
  [commentActivity whereKey:kDTActivityChallengeDayKey
          equalTo:[PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:self.challengeDay.objectId]];
  [commentActivity whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeComment];
  
  
  
  PFQuery *verificationActivity = [PFQuery queryWithClassName:kDTActivityClassKey];
  [verificationActivity whereKey:kDTActivityChallengeDayKey
                 equalTo:[PFObject objectWithoutDataWithClassName:kDTChallengeDayClassKey objectId:self.challengeDay.objectId]];
  [verificationActivity whereKey:kDTActivityTypeKey equalTo:kDTActivityTypeVerificationFinish];
  
  PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:commentActivity,verificationActivity,nil]];
  [query setCachePolicy:kPFCachePolicyNetworkOnly];
  [query includeKey:kDTActivityVerificationKey];

// If no objects are loaded in memory, we look to the cache first to fill the table
// and then subsequently do a query against the network.
  
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PFObject *objectForRow = [self.objects objectAtIndex:indexPath.row];

  if([[objectForRow objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeComment])
  {
    return [DTBaseCommentCell heightForCellTextContent:[objectForRow objectForKey:kDTActivityContentKey]
                        hasImageContent:([objectForRow objectForKey:kDTActivityImageKey] != nil)
                         cellInsetWidth:kCommentCellInsetWidth];
  }
  
  if([[objectForRow objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeVerificationFinish])
  {
    return [DTVerificationCell heightForCellTextContent:[[objectForRow objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationStatusContentKey]
                                       hasImageContent:([[objectForRow objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationImageKey] != nil)
                                        cellInsetWidth:kCommentCellInsetWidth];
  }

  return 40; //generic cell height (something went wrong)
}

//+ (CGFloat)heightForCellTextContent:(NSString *)textContent hasImageContent:(BOOL)imageContent cellInsetWidth:(CGFloat)cellInset


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
  static NSString *CommentCellID = @"CommentCell";
  static NSString *VerificationCellID = @"VerificationCell";

  // Try to dequeue a cell and create one if necessary
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"generic"];

  
  if ([[object objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeComment] ) {
    DTBaseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellID];
    if (cell == nil) {
      cell = [[DTBaseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellID];
      cell.cellInsetWidth = kCommentCellInsetWidth;
      cell.delegate = self;
    }
    
    if (object) {
      [cell setUser:[object objectForKey:kDTActivityFromUserKey]];
      [cell setContentText:[object objectForKey:kDTActivityContentKey]];
      
      if ([object objectForKey:kDTActivityImageKey] != nil)
      {
        cell.contentImageView.image = [UIImage imageNamed:@"commentImagePlaceholder.jpg"];
        
        [[object objectForKey:kDTActivityImageKey] fetchIfNeededInBackgroundWithBlock:^(PFObject *image, NSError *error){
          [cell.contentImageView setFile:[image objectForKey:kDTImageMediumKey]];
          if ([cell.contentImageView.file isDataAvailable]) {
            [cell.contentImageView loadInBackground];
          }
        }];
      }
      [cell setDate:[object createdAt]];
    }
    return cell;
  }

  if ([[object objectForKey:kDTActivityTypeKey] isEqualToString:kDTActivityTypeVerificationFinish]) {
    DTVerificationCell *cell = [tableView dequeueReusableCellWithIdentifier:VerificationCellID];
    if (cell == nil) {
      cell = [[DTVerificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VerificationCellID];
      cell.cellInsetWidth = kCommentCellInsetWidth;
      cell.delegate = self;
    }
    
    if (object) {
      [cell setUser:[object objectForKey:kDTActivityFromUserKey]];
      [cell setContentText:[[object objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationStatusContentKey]];
      [cell setOrdinal:[[object objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationOrdinalKey]];
      [cell setVerificationType:(DTVerificationType)[[[object objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationTypeKey] intValue]];
      
      if ([[object objectForKey:kDTActivityVerificationKey] objectForKey:kDTVerificationImageKey] != nil)
      {
        cell.contentImageView.image = [UIImage imageNamed:@"commentImagePlaceholder.jpg"];
        
        [[object objectForKey:kDTActivityImageKey] fetchIfNeededInBackgroundWithBlock:^(PFObject *image, NSError *error){
          [cell.contentImageView setFile:[image objectForKey:kDTImageMediumKey]];
          if ([cell.contentImageView.file isDataAvailable]) {
            [cell.contentImageView loadInBackground];
          }
        }];
      }
      [cell setDate:[object createdAt]];
    }
    return cell;
  }
  
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
