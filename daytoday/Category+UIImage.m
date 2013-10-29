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

+ (NSString *)stringForType:(DTCategoryType)type
{
  NSString *name = @"UNDEFINED CATEGORY"; //NOT FOR DISPLAY PURPOSES
  
  switch (type) {
    case DTCategoryFitness:
      name = NSLocalizedString(@"FITNESS", @"fitness category type");
      break;
    case DTCategoryDiet:
      name = NSLocalizedString(@"DIET", @"diet category type");
      break;
    case DTCategoryProductivity:
      name = NSLocalizedString(@"PRODUCTIVITY", @"productivity category type");
      break;
    case DTCategoryEducation:
      name = NSLocalizedString(@"EDUCATION", @"education category type");
      break;
    case DTCategoryHobby:
      name = NSLocalizedString(@"HOBBY", @"hobby category type");
      break;
    case DTCategoryLove:
      name = NSLocalizedString(@"LOVE", @"love category type");
      break;
    case DTCategoryMoney:
      name = NSLocalizedString(@"MONEY", @"money category type");
      break;
    case DTCategoryWildCard:
      name = NSLocalizedString(@"USER DEFINED", @"user defined category type");
      break;
    default:
      break;
  }
  return name;
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
