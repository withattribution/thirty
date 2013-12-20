//
//  DTGlobalNavigation.h
//  daytoday
//
//  Created by pasmo on 12/19/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DTGlobalButtonType) {
  DTGlobalButtonTypeGlobal,
  DTGlobalButtonTypeFomo,
  DTGlobalButtonTypeComment,
  DTGlobalButtonTypeShare,
  DTGlobalButtonTypeHeart
};

typedef NS_ENUM(NSUInteger, DTGlobalNavType) {
  DTGlobalNavTypeGeneric,
  DTGlobalNavTypeSocial,
};

@protocol DTGlobalNavigationDelegate <NSObject>

@optional
- (void)userDidTapGlobalNavigationButtonType:(DTGlobalButtonType)type;
@end

@interface DTGlobalNavigation : UIView

@property (nonatomic,weak) id<DTGlobalNavigationDelegate> delegate;

@property (nonatomic,strong) UIView *mainView;

@property (nonatomic,strong) UIButton *globalNavButton;
@property (nonatomic,strong) UIButton *fomoButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) UIButton *heartButton;

@property (nonatomic,assign) CGFloat insetWidth;

+ (id)globalNavigationWithType:(DTGlobalNavType)type;
- (id)initWithFrame:(CGRect)frame type:(DTGlobalNavType)type;

#define dtVertBorder 2.f
#define dtVertElement 4.f

#define dtHoriBorder 2.f
#define dtHoriElement 4.f

#define dtGlobalButtonY dtVertBorder+dtVertElement
#define dtGlobalButtonHeight 40.f
#define dtGlobalButtonWidth 34.f
#define dtFomoButtonWidth dtGlobalButtonWidth+15.f
#define dtGlobalNavHeight ((2*dtVertBorder)+(2*dtVertElement)+dtGlobalButtonHeight)

@end
