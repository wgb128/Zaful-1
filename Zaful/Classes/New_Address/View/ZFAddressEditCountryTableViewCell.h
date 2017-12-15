//
//  ZFAddressEditCountryTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

@interface ZFAddressEditCountryTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, assign) BOOL                      isContinueCheck;

@end
