//
//  CouponCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyCouponsListModel.h"

@interface CouponCell : UITableViewCell

@property (nonatomic, strong) NSNumber *currentTime;

@property (nonatomic, strong) MyCouponsListModel *couponModel;

@end
