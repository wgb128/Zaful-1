//
//  ZFMyCouponViewController.h
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface ZFMyCouponViewController : ZFBaseViewController

@property (nonatomic, copy) void(^applyCouponHandle)(NSString *couponCode);
@property (nonatomic, strong) NSArray *availableArray;
@property (nonatomic, strong) NSArray *disabledArray;
@property (nonatomic, copy) NSString *couponCode;
@property (nonatomic, copy) NSString *couponAmount;

@end
