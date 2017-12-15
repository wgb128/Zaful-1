//
//  ZFMyCouponViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFMyCouponModel;
@interface ZFMyCouponViewModel : NSObject

@property (nonatomic, copy) void(^itemSelectedHandle)(ZFMyCouponModel *model);
@property (nonatomic, strong) UIViewController *viewController;
- (instancetype)initWithAvailableCoupon:(NSArray <ZFMyCouponModel *>*)availableCoupon
                          disableCoupon:(NSArray <ZFMyCouponModel *>*)disableCoupon
                             couponCode:(NSString *)couponCode
                           couponAmount:(NSString *)couponAmount;
- (void)selectedBefore; // 开始进入的选择判断

@end
