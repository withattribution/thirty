//
//  CommonRequestsSpec.M
//  daytoday
//
//  Created by peanut on 6/13/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "Specs.h"
#import "DTCommonRequests+Spec.h"

SpecBegin(CommonRequestBehaviors)

//when in the philippines LOLZ
setAsyncSpecTimeout(20.0);

NSString *const kTestingUserName                        =@"Fixture Username";
NSString *const kTestingUserPassword                    =@"Fixture Password";
NSString *const kTestingChallengeId                     =@"hxVdpImcUK";

xdescribe(@"User Entry: Login", ^{
  //Log out any user that has persisted
  describe(@"Logout user to so that we're starting at a known state", ^{
    it(@"current user should not exist", ^{
      waitUntil(^(DoneCallback done) {
        [[DTCommonRequests logoutCurrentUser]
         continueWithBlock:^id(BFTask *task){
            expect([PFUser currentUser]).to.beNil();
            done();
            return nil;
        }];
      });
    });
    it(@"should no longer have a pinned intent", ^{
      waitUntil(^(DoneCallback done) {
        [[DTCommonRequests helperRetrievePinnedActiveIntentFromCurrentUser]
         continueWithBlock:^id(BFTask *pinned){
           expect(pinned.result).to.beNil();
           done();
           return nil;
         }];
      });
    });
    it(@"cache should not have active intent for current user", ^{
      expect([[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]).to.beNil();
    });
  });

  describe(@"Log in user", ^{
    it(@"should be test user", ^{
      waitUntil(^(DoneCallback done) {
        [[DTCommonRequests logInWithUserCredential:kTestingUserName
                                          password:kTestingUserPassword]
         continueWithBlock:^id(BFTask *task){
           expect([PFUser currentUser].username).to.equal(kTestingUserName);
           done();
           return nil;
        }];
      });
    });
      //logged in user removes intent to start from known state
      context(@"removing active intent",^{
        it(@"active intent should be not exist", ^{
          waitUntil(^(DoneCallback done) {
            [[DTCommonRequests leaveChallenge]
             continueWithBlock:^id(BFTask *task){
               expect([[PFUser currentUser] objectForKey:kDTUserActiveIntent]).to.beNil();
               done();
               return nil;
             }];
          });
        });
        it(@"pinned active intent should not exist", ^{
          waitUntil(^(DoneCallback done) {
            [[DTCommonRequests helperRetrievePinnedActiveIntentFromCurrentUser]
             continueWithBlock:^id(BFTask *pinned){
               expect(pinned.result).to.beNil();
               done();
               return nil;
             }];
          });
        });
        it(@"cached active intent should not exist", ^{
          waitUntil(^(DoneCallback done) {
            expect([[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]).to.beNil();
            done();
          });
        });
      });
      //logged in user joins a challenge
      context(@"User joining a challenge", ^{
        it(@"should have a pinned active intent", ^{
          waitUntil(^(DoneCallback done) {
            [[DTCommonRequests joinChallenge:kTestingChallengeId] continueWithBlock:^id(BFTask *task){
              return [[DTCommonRequests helperRetrievePinnedActiveIntentFromCurrentUser]
                      continueWithBlock:^id(BFTask *pinned){
                        expect(pinned.result).notTo.beNil();
                        done();
                        return nil;
                      }];
            }];
          });
        });
        it(@"cache should have active intent for current user", ^{
          expect([[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]).notTo.beNil();
        });
        it(@"cached intent should match test challenge id", ^{
          expect([[[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] objectForKey:kDTIntentChallengeKey] objectId]).to.equal(kTestingChallengeId);
        });
        it(@"user active intent should match cached intent", ^{
          waitUntil(^(DoneCallback done) {
            [[DTCommonRequests helperGetCurrentUserObjectFromService] continueWithBlock:^id(BFTask *task){
              expect([[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]] objectId]).to.equal([[task.result objectForKey:kDTUserActiveIntent] objectId]);
              done();
              return nil;
            }];
          });
        });
        it(@"intent should have pinned days", ^{
          waitUntil(^(DoneCallback done) {
            [[DTCommonRequests helperGetDaysFromLocalStoreForActiveIntent:[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]] continueWithBlock:^id(BFTask *days){
              expect(days.result).to.haveCountOf([[[[[DTCache sharedCache] activeIntentForUser:[PFUser currentUser]]
                                                                                  objectForKey:kDTIntentChallengeKey]
                                                                                  objectForKey:kDTChallengeDurationKey] integerValue]);
              done();
              return nil;
            }];
          });
        });
        
      });
  });
});
SpecEnd
