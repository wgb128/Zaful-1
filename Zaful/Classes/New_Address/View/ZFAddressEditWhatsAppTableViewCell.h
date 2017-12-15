//
//  ZFAddressEditWhatsAppTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/19.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;
typedef void(^AddressEditWhatsappCheckErrorCompletionHandler)(BOOL isOverLength, NSString *whatsapp);
typedef void(^AddressEditWhatsappCancelOverLengthCompletionHandler)(NSString *whatsapp);
@interface ZFAddressEditWhatsAppTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;
@property (nonatomic, assign) BOOL                          isContinueCheck;
@property (nonatomic, assign) BOOL                          isOverLength;

@property (nonatomic, copy) AddressEditWhatsappCheckErrorCompletionHandler       addressEditWhatsappCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditWhatsappCancelOverLengthCompletionHandler addressEditWhatsappCancelOverLengthCompletionHandler;
@end
