//
//  ZFAddressEditAddressTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef NS_ENUM(NSInteger, ZFAddressEditAddressType) {
    ZFAddressEditAddressTypeFirstAddress = 0,
    ZFAddressEditAddressTypeSecondAddress
};

typedef void(^AddressEditAddressCheckErrorCompletionHandler)(BOOL isOverLength, NSString *address);
typedef void(^AddressEditAddressCancelOverLengthCompletionHandler)(NSString *address);

@interface ZFAddressEditAddressTableViewCell : UITableViewCell

@property (nonatomic, assign) ZFAddressEditAddressType      editAddressType;
@property (nonatomic, strong) ZFAddressInfoModel            *model;

@property (nonatomic, assign) BOOL                          isContinueCheck;
@property (nonatomic, assign) BOOL                          isOverLength;

@property (nonatomic, copy) AddressEditAddressCheckErrorCompletionHandler       addressEditAddressCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditAddressCancelOverLengthCompletionHandler addressEditAddressCancelOverLengthCompletionHandler;

@end
