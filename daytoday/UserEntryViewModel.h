//
//  UserEntryModel.h
//  daytoday
//
//  Created by peanut on 6/23/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

//typedef NS_ENUM(NSInteger, UserEntryType) {
//  UserLogIn = 0,
//  UserSignUp
//};

@interface UserEntryViewModel : NSObject

@property (nonatomic,strong) NSString *usernameCredential;
@property (nonatomic,strong) NSString *passwordCredential;
@property (nonatomic,strong) NSString *emailCredential;

- (BOOL)isValidUserName:(NSString *)name;
- (BOOL)isValidPassword:(NSString *)pass;
- (BOOL)isValidEmailAddress:(NSString *)email;

@end
