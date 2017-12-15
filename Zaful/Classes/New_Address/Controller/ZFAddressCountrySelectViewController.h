//
//  ZFAddressCountrySelectViewController.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
@class ZFAddressCountryModel;

typedef void(^AddressCountrySelectCompletionHandler)(ZFAddressCountryModel *model);

@interface ZFAddressCountrySelectViewController : ZFBaseViewController

@property (nonatomic, copy) AddressCountrySelectCompletionHandler       addressCountrySelectCompletionHandler;

@end
