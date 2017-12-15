//
//  ZFAddressEditZipCodeTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;

typedef void(^AddressEditZipCodeCheckErrorCompletionHandler)(BOOL isOverLength, NSString *zipCode);
typedef void(^AddressEditZipCodeCancelOverLengthCompletionHandler)(NSString *zipCode);

@interface ZFAddressEditZipCodeTableViewCell : UITableViewCell
@property (nonatomic, strong) ZFAddressInfoModel        *model;
@property (nonatomic, copy)   NSString                  *countryId;
@property (nonatomic, assign) BOOL                      isContinueCheck;
@property (nonatomic, assign) BOOL                      isOverLength;
@property (nonatomic, copy) AddressEditZipCodeCheckErrorCompletionHandler       addressEditZipCodeCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditZipCodeCancelOverLengthCompletionHandler addressEditZipCodeCancelOverLengthCompletionHandler;
@end
