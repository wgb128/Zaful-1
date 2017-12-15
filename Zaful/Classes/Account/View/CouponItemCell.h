//
//  CouponItemCell.h
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponType) {
    CouponUnused = 1,
    CouponUsed,
    CouponExpired
};

@class CouponItemModel;

@interface CouponItemCell : UITableViewCell
@property (nonatomic, strong) NSNumber *currentTime;
@property (nonatomic, strong) CouponItemModel *couponModel;
@property (nonatomic, copy) void(^userItActionHandle)();
@property (nonatomic, copy) void(^tagBtnActionHandle)();
@property (nonatomic, assign) CouponType couponType;

+ (CouponItemCell *)couponItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
