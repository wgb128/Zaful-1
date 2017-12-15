//
//  ZFAddressEditNameTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef NS_ENUM(NSInteger, ZFAddressNameType) {
    ZFAddressNameTypeFirstName = 0,
    ZFAddressNameTypeLastName = 1,
};

typedef void(^AddressEditNameCheckErrorCompletionHandler)(BOOL isOverLength, NSString *name);
typedef void(^AddressEditNameCancelOverLengthCompletionHandler)(NSString *name);

@interface ZFAddressEditNameTableViewCell : UITableViewCell
@property (nonatomic, assign) ZFAddressNameType         addressNameType;
@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isOverLength;
@property (nonatomic, copy) AddressEditNameCheckErrorCompletionHandler          addressEditNameCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditNameCancelOverLengthCompletionHandler    addressEditNameCancelOverLengthCompletionHandler;
@end
