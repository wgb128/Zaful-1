//
//  ZFAddressEditPhoneNumberTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressCountryCodeSelectCompletionHandler)(void);
typedef void(^AddressEditPhoneNumberCheckErrorCompletionHandler)(BOOL error, NSString *tel, NSString *resultTel);
typedef void(^AddressEditSelctCountryFirstTipsCompletionHandler)(void);

@interface ZFAddressEditPhoneNumberTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isErrorEnter;
@property (nonatomic, copy) AddressCountryCodeSelectCompletionHandler           addressCountryCodeSelectCompletionHandler;

@property (nonatomic, copy) AddressEditPhoneNumberCheckErrorCompletionHandler   addressEditPhoneNumberCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditSelctCountryFirstTipsCompletionHandler   addressEditSelctCountryFirstTipsCompletionHandler;

@end
