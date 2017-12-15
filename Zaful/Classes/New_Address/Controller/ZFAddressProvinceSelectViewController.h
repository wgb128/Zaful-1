//
//  ZFProvinceSelectViewController.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
@class ZFAddressStateModel;

typedef void(^AddressProvinceSelectCompletionHandler)(ZFAddressStateModel *model);

@interface ZFAddressProvinceSelectViewController : ZFBaseViewController

@property (nonatomic, copy) NSString        *regionId;
@property (nonatomic, copy) AddressProvinceSelectCompletionHandler      addressProvinceSelectCompletionHandler;

@end
