//
//  ZFAddressViewController.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
@class ZFAddressInfoModel;

typedef NS_ENUM(NSInteger, AddressInfoShowType) {
    AddressInfoShowTypeAccount = 0,
    AddressInfoShowTypeCart
};

typedef void(^AddressChooseCompletionHandler)(ZFAddressInfoModel *model);

@interface ZFAddressViewController : ZFBaseViewController

@property (nonatomic, copy) AddressChooseCompletionHandler      addressChooseCompletionHandler;

@property (nonatomic, assign) AddressInfoShowType               showType;

@end
