//
//  Category+UIImage.m
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import "Category+UIImage.h"

@implementation Category_UIImage

+ (UIImage *)imageForType:(DTCategoryType)type
{
  UIImage *image = [UIImage imageNamed:@""];
  
  switch (type) {
    case DTCategoryFitness:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryDiet:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryProductivity:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryEducation:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryHobby:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryLove:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryMoney:
      image = [UIImage imageNamed:@""];
      break;
    case DTCategoryWildCard:
      image = [UIImage imageNamed:@""];
      break;
    default:
      break;
  }
  return image;
}

+ (NSArray *)categoryImages
{
  NSMutableArray *images = [NSMutableArray arrayWithObjects:
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            [UIImage imageNamed:@""],
                            nil];
  return images;
}

@end
