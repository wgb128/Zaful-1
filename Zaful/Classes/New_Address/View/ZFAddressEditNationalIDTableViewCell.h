//
//  ZFAddressEditNationalIDTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditNationalTipsShowCompletionHandler)(void);
typedef void(^AddressEditNationalCheckErrorCompletionHandler)(BOOL isErrorEnter, NSString *nationalId);


@interface ZFAddressEditNationalIDTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;
@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isErrorEnter;

@property (nonatomic, copy) AddressEditNationalTipsShowCompletionHandler        addressEditNationalTipsShowCompletionHandler;

@property (nonatomic, copy) AddressEditNationalCheckErrorCompletionHandler      addressEditNationalCheckErrorCompletionHandler;


@end
