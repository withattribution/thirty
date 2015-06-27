//
//  UserEntryModel.m
//  daytoday
//
//  Created by peanut on 6/23/15.
//  Copyright (c) 2015 Studio A-OK, LLC. All rights reserved.
//

#import "UserEntryViewModel.h"

@implementation UserEntryViewModel

- (BOOL)isValidUserName:(NSString *)name
{
  return (name.length >= 2);
}

- (BOOL)isValidPassword:(NSString *)pass
{
  return (pass.length >= 6);
}

- (BOOL)isValidEmailAddress:(NSString *)email
{
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:email];
}



@end
