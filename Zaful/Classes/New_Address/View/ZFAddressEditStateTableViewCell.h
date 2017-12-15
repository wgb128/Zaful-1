//
//  ZFAddressEditStateTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditStateCompletionHandler)(NSString *province);
typedef void(^AddressEditStateCheckErrorCompletionHandler)(BOOL isOverLength, NSString *province);
typedef void(^AddressEditStateCancelOverLengthCompletionHandler)(NSString *province);

@interface ZFAddressEditStateTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel        *model;

@property (nonatomic, assign) BOOL                      hasProvince;

@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isOverLength;

@property (nonatomic, copy) AddressEditStateCompletionHandler                   addressEditStateCompletionHandler;
@property (nonatomic, copy) AddressEditStateCheckErrorCompletionHandler         addressEditStateCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditStateCancelOverLengthCompletionHandler   addressEditStateCancelOverLengthCompletionHandler;
@end
