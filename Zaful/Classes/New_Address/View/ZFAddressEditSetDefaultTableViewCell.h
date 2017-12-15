//
//  ZFAddressEditSetDefaultTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditSetDefaultCompeltionHandler)(BOOL  isDefault);

@interface ZFAddressEditSetDefaultTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL      isDefaultAddress;
@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, copy) AddressEditSetDefaultCompeltionHandler      addressEditSetDefaultCompeltionHandler;
@end
