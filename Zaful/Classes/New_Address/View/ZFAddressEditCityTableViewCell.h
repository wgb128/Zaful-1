//
//  ZFAddressEditCityTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditCityCompletionHandler)(NSString *city);
typedef void(^AddressEditCityCheckErrorCompletionHandler)(BOOL isOverLength, NSString *city);
typedef void(^AddressEditCityCancelOverLengthCompletionHandler)(NSString *city);

@interface ZFAddressEditCityTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;
@property (nonatomic, assign) BOOL                      hasCity;

@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isOverLength;

@property (nonatomic, copy) AddressEditCityCompletionHandler                    addressEditCityCompletionHandler;
@property (nonatomic, copy) AddressEditCityCheckErrorCompletionHandler          addressEditCityCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditCityCancelOverLengthCompletionHandler    addressEditCityCancelOverLengthCompletionHandler;
@end
