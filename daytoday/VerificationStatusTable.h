//
//  VerificationStatusTable.h
//  daytoday
//
//  Created by pasmo on 12/17/13.
//  Copyright (c) 2013 Studio A-OK, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol VerificationStatusTableDelegate <NSObject>

@optional
- (void)didTapCancelButton:(UIButton *)aButton;
@end

@interface VerificationStatusTable : UITableView

@property (nonatomic,weak) id<VerificationStatusTableDelegate> cancelDelegate;

@property (nonatomic,strong) UIImageView *imageViewToUpload;
@property (nonatomic,strong) MKMapView *mapToUpload;

@property (nonatomic,strong) PFObject *challenge;
@property (nonatomic,strong) PFObject *challengeDay;

@end
