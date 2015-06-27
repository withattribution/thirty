//
//  CommonRequestsSpec.M
//  daytoday
//
//  Created by peanut on 6/13/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "Specs.h"

SpecBegin(CommonRequests)
  describe(@"intent", ^{
    __block PFUser *currentUser;

    beforeEach(^{
      currentUser = [PFUser currentUser];
    });

    describe(@"intent retrieval", ^{
      context(@"when user is logged in", ^{
        it(@"user should not be nil", ^{
          NSLog(@"the user: %@",currentUser.username);
          expect(currentUser.username).notTo.equal(nil);
        });
      });

      context(@"when user has an active intent", ^{

      });

      context(@"when user does not have an active intent", ^{

      });
    });
    
    afterEach(^{
      [PFUser logOut];
    });

  });
SpecEnd