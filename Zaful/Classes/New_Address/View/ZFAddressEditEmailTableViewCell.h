//
//  ZFAddressEditEmailTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditEmailCheckErrorCompletionHandler)(BOOL isOverLength, NSString *email);
typedef void(^AddressEditEmailCancelOverLengthCompletionHandler)(NSString *email);

@interface ZFAddressEditEmailTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;
@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isOverLength;

@property (nonatomic, copy) AddressEditEmailCheckErrorCompletionHandler         addressEditEmailCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditEmailCancelOverLengthCompletionHandler   addressEditEmailCancelOverLengthCompletionHandler;
@end
