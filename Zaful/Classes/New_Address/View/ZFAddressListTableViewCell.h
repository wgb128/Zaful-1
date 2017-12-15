//
//  ZFAddressListTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFAddressInfoModel;

typedef void(^AddressEditSelectCompletionHandler)(ZFAddressInfoModel *model);

@interface ZFAddressListTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, copy) AddressEditSelectCompletionHandler          addressEditSelectCompletionHandler;

@end
