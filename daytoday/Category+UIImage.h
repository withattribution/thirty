//
//  Category+UIImage.h
//  daytoday
//
//  Created by pasmo on 10/29/13.
//  Copyright (c) 2013 Submarine Rich, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//This is a fake category for category's as related to their associated images
//When and if a model class shows up I'll just use this logic and extend that model
//base class

typedef NS_ENUM(NSInteger, DTCategoryType) {
  DTCategoryFitness,
  DTCategoryDiet,
  DTCategoryProductivity,
  DTCategoryEducation,
  DTCategoryHobby,
  DTCategoryLove,
  DTCategoryMoney,
  DTCategoryWildCard
};

@interface Category_UIImage : NSObject

+ (UIImage *)imageForType:(DTCategoryType)type;
+ (NSArray *)categoryImages;

@end
