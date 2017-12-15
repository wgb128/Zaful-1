//
//  ZFAddressEditViewController.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
@class ZFAddressInfoModel;
typedef void(^AddressEditSuccessCompletionHandler)(void);

@interface ZFAddressEditViewController : ZFBaseViewController

@property (nonatomic, strong) ZFAddressInfoModel                    *model;

@property (nonatomic, copy) AddressEditSuccessCompletionHandler     addressEditSuccessCompletionHandler;
@end
