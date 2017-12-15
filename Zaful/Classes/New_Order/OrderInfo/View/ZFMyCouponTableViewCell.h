//
//  ZFMyCouponTableViewCell.h
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponType) {
    CouponAvailable,
    CouponDisabled
};

@class ZFMyCouponModel;
@interface ZFMyCouponTableViewCell : UITableViewCell

@property (nonatomic, assign) CouponType couponType;
@property (nonatomic, copy) void(^tagBtnActionHandle)();

- (void)configWithModel:(ZFMyCouponModel *)model;
+ (ZFMyCouponTableViewCell *)couponItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
