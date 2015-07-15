/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import "FrontViewController.h"

//DTProgressRow TESTING
#import "DTChallengeCalendarSpecHelpers.h"
#import "DTChallengeCalendar.h"
#import "DTProgressRow.h"
//DTProgressRow TESTING

@interface FrontViewController() <DTGlobalNavigationDelegate>

@end

@implementation FrontViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  self.revealController = [self revealViewController];
  
  [self buildDemoInterface];
//  [self buildProgressRowTestingInterface];
//  [self buildActiveDayTestingInterface];

  self.globalNavigation = [DTGlobalNavigation globalNavigationWithType:DTGlobalNavTypeGeneric];
  [self.globalNavigation setInsetWidth:5.f];
  [self.globalNavigation setDelegate:self];
  [self.view addSubview:self.globalNavigation];
}

- (void)userDidTapGlobalNavigationButtonType:(DTGlobalButtonType)type
{
  if(type == DTGlobalButtonTypeGlobal)
  {
    [self.revealController revealToggle:self];
  }
}

- (void)buildActiveDayTestingInterface
{
  [[DTCommonRequests retrieveActiveChallengeDayForDate:[NSDate date] user:[PFUser currentUser]]
   continueWithBlock:^id(BFTask *task){
     if (!task.error) {
       return [[DTCommonRequests retrieveDaysForIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]]
               continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *ts){
                 if (!ts.error) {
                   CGRect rowRect = CGRectMake(0.f,
                                               40.f,
                                               self.view.frame.size.width,
                                               40.f);
                   TICK;
                   DTChallengeCalendar *calendarObject = [DTChallengeCalendar calendarWithIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]];
                   DTProgressRow *rowView = [[DTProgressRow alloc] initWithFrame:rowRect];
                   [rowView setDataSource:calendarObject];
                   [rowView setRowInset:5.0f];
                   [self.view addSubview:rowView];
                   [rowView reloadData:YES date:[NSDate date]];
                   TOCK;
                 }
                 return nil;
               }];
     }
     return nil;
  }];
}


- (void)buildProgressRowTestingInterface
{
  PFObject *intent = [DTChallengeCalendarSpecHelpers intentEndingInOneWeek];
  DTChallengeCalendar *challengeCalendar = [DTChallengeCalendar calendarWithIntent:intent];
  CGRect rowRect = CGRectMake(0.f,
                              40.f,
                              self.view.frame.size.width,
                              40.f);
  
  DTProgressRow *prow1 = [[DTProgressRow alloc] initWithFrame:rowRect];
  [prow1 setDataSource:challengeCalendar];
  [prow1 setRowInset:5.0f];
  [self.view addSubview:prow1];
  [prow1 reloadData:YES date:[DTChallengeCalendarSpecHelpers startingDate:intent]];
  
  rowRect.origin.y += 50.0f;
  
  DTProgressRow *prow2 = [[DTProgressRow alloc] initWithFrame:rowRect];
  [prow2 setDataSource:challengeCalendar];
  [prow2 setRowInset:5.0f];
  [self.view addSubview:prow2];
  [prow2 reloadData:YES date:[DTChallengeCalendarSpecHelpers oneWeekAfterStarting:intent]];
  
  rowRect.origin.y += 50.0f;
  
  DTProgressRow *prow3 = [[DTProgressRow alloc] initWithFrame:rowRect];
  [prow3 setDataSource:challengeCalendar];
  [prow3 setRowInset:5.0f];
  [self.view addSubview:prow3];
  [prow3 reloadData:YES date:[DTChallengeCalendarSpecHelpers halfWayDone:intent]];
  
  rowRect.origin.y += 50.0f;
  
  DTProgressRow *prow4 = [[DTProgressRow alloc] initWithFrame:rowRect];
  [prow4 setDataSource:challengeCalendar];
  [prow4 setRowInset:5.0f];
  [self.view addSubview:prow4];
  [prow4 reloadData:YES date:[DTChallengeCalendarSpecHelpers lastWeekUntilEnding:intent]];
}

- (void)buildDemoInterface
{
  [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"daytoday.jpg"]]];
}

@end