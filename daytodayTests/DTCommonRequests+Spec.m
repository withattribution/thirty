//
//  DTCommonRequests+Spec.m
//  daytoday
//
//  Created by peanut on 7/5/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "DTCommonRequests.h"
#import "DTCommonRequests+Spec.h"

@implementation DTCommonRequests (Specs)

+ (BFTask *)helperRetrievePinnedActiveIntentFromCurrentUser
{
  PFQuery *query = [PFQuery queryWithClassName:kDTIntentClassKey];
  [query fromPinWithName:kDTPinnedActiveIntent];
  return [query getFirstObjectInBackground];
}

+ (BFTask *)helperGetCurrentUserObjectFromService
{
  PFQuery *userQuery = [PFUser query];
  [userQuery includeKey:kDTUserActiveIntent];
  return [userQuery getObjectInBackgroundWithId:[PFUser currentUser].objectId];
}

+ (BFTask *)helperGetDaysFromLocalStoreForActiveIntent:(PFObject *)intent
{
  PFQuery *dayQuery = [PFQuery queryWithClassName:kDTChallengeDayClassKey];
  [dayQuery fromPinWithName:kDTPinnedActiveChallengeDays];
  return [dayQuery findObjectsInBackground];
}

@end

//  NSString *const kTestingUserEmail                       =@"Fixture@Email.Com";

//  __strong Class mockDTCommonRequests = mockClass([DTCommonRequests class]);
//  setAsyncSpecTimeout(240.0);
//  NIDINFO(@"the info: %@",[[[NSProcessInfo processInfo] environment] objectForKey:@"SPECTA_NO_SHUFFLE"]);

//    it(@"", ^{
//      waitUntil(^(DoneCallback done) {
//
//      });
//    });

//  context(@"LogIn or Sign Up", ^{
//    //Create local test user
//    user = [PFUser user];
//    user.username = kTestingUserName;
//    user.password = kTestingUserPassword;
//    user.email    = kTestingUserEmail;
//    context(@"butts", ^{
//    waitUntil(^(DoneCallback done) {
//      NSLog(@"logging in");
//      [[PFUser logInWithUsernameInBackground:user.username
//                                    password:user.password]
//       continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task){
//           NIDINFO(@"what? :%@",task);
//         if(task.error){
//           //did not find the user so there must not be one in the database
//           [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
//             if(error)
//               NIDINFO(@"error: %@",[error localizedDescription]);
//             done();
//           }];
//         }else {
//           user = task.result;
//           done();
//         }
//         return nil;
//       }];// waitUntilFinished];
//    });
//
//    it(@"should be a current user", ^{
//      expect([PFUser currentUser]).notTo.beNil();
//    });
//    });
//    it(@"should be test user", ^{
//      expect([PFUser currentUser].username).to.equal(kTestingUserName);
//    });
//  });

//example of mocking a call
//    xcontext(@"retrieve intent from current user with active intent from service", ^{
//      it(@"should query the service", ^{
//        [given([mockDTCommonRequests queryPinnedIntentForUser:user]) willReturn:task];
//        [mockDTCommonRequests queryPinnedIntentForUser:user];
//        [verify(mockDTCommonRequests) queryPinnedIntentForUser:user];
//      });
//    });
//  });
