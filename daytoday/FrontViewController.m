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
#import "SWRevealViewController.h"

@interface FrontViewController()

@end

@implementation FrontViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
  SWRevealViewController *revealController = [self revealViewController];
  
  UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                       style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
  
  self.navigationItem.leftBarButtonItem = revealButtonItem;
  
  [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"daytoday.jpg"]]];
  
  [self.navigationController.navigationBar setHidden:NO];
	self.title = NSLocalizedString(@"DEMO MODE", nil);
}

//Sample code for generating parts of the challenge day for testing and demo usage

// build a challenge day model
//  PFQuery *currentChallengeDay = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
//
//  [currentChallengeDay whereKey:@"objectId" equalTo:@"v9xN4EbG71"];
//
//  [currentChallengeDay getObjectInBackgroundWithId:@"v9xN4EbG71" block:^(PFObject *obj, NSError *err){
//    if(!err){
//      self.challengeDayId = obj.objectId;
//      NIDINFO(@"got object id: %@",self.challengeDayId);
//      [self addChallengeDayInterface];
//    }else{
//      NIDINFO(@"%@",[err localizedDescription]);
//    }
//  }];

//  One time only make a challenge day object so that we can reuse the challenge day object id to build out the comment interface

//  PFObject *challengeDay = [PFObject objectWithClassName:kDTChallengeDayClassKey];
//  challengeDay[kDTChallengeDayTaskRequiredCountKey] = @3;
//  challengeDay[kDTChallengeDayTaskCompletedCountKey] = @1;
//  challengeDay[kDTChallengeDayOrdinalDayKey] = @14;
//  challengeDay[kDTChallengeDayAccomplishedKey] = @NO;
//
//  [challengeDay saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//
//    if (succeeded){
//      NIDINFO(@"succeeded!");
//    }else {
//      NIDINFO(@"%@",[err localizedDescription]);
//    }
//  }];

// build an intent model

//create an example intent: save it:
//      PFObject *intent = [PFObject objectWithClassName:kDTIntentClassKey];
//      [intent setObject:[NSDate dateWithTimeInterval:(60.*60.*24*14*-1) sinceDate:[NSDate date]] forKey:kDTIntentStartingKey];
//      [intent setObject:[NSDate dateWithTimeInterval:(60.*60.*24*14*1) sinceDate:[NSDate date]] forKey:kDTIntentEndingKey];
//      [intent setObject:[PFUser currentUser] forKey:kDTIntentUserKey];
//
//      [intent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//        if(succeeded){
//          NIDINFO(@"saved an example intent!");
//          self.challengeDay[kDTChallengeDayIntentKey] = [PFObject objectWithoutDataWithClassName:kDTIntentClassKey objectId:intent.objectId];
//          [self.challengeDay saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err){
//            if(succeeded){
//              NIDINFO(@"now we have an intent referencing the challenge day which is how we include the user for the challenge day");
//            }else {
//              NIDINFO(@"%@",[error localizedDescription]);
//            }
//          }];
//
//        }
//        else {
//          NIDINFO(@"%@",[error localizedDescription]);
//        }
//      }];

//      NIDINFO(@"date past: %@",[NSDate dateWithTimeInterval:(60.*60.*24*14*-1) sinceDate:[NSDate date]]);
//      NIDINFO(@"date NOW: %@",[NSDate date]);
//      NIDINFO(@"date future: %@",[NSDate dateWithTimeInterval:(60.*60.*24*14*1) sinceDate:[NSDate date]]);

@end