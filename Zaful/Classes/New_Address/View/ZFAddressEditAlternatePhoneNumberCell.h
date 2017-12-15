//
//  ZFAddressEditAlternatePhoneNumberCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/19.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFAddressInfoModel;

typedef void(^AddressCountryCodeSelectCompletionHandler)(void);
typedef void(^AddressEditAlPhoneNumberCheckErrorCompletionHandler)(BOOL error, NSString *tel);
typedef void(^AddressEditSelctCountryFirstTipsCompletionHandler)(void);

@interface ZFAddressEditAlternatePhoneNumberCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isErrorEnter;
@property (nonatomic, copy) AddressCountryCodeSelectCompletionHandler           addressCountryCodeSelectCompletionHandler;

@property (nonatomic, copy) AddressEditAlPhoneNumberCheckErrorCompletionHandler   addressEditPhoneNumberCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditSelctCountryFirstTipsCompletionHandler   addressEditSelctCountryFirstTipsCompletionHandler;

@end
