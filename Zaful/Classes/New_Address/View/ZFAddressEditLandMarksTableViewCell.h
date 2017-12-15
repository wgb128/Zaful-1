//
//  ZFAddressEditLandMarksTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/19.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;
typedef void(^AddressEditLandmarkCheckErrorCompletionHandler)(BOOL isOverLength, NSString *landmark);
typedef void(^AddressEditLandmarkCancelOverLengthCompletionHandler)(NSString *landmark);
@interface ZFAddressEditLandMarksTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel            *model;

@property (nonatomic, assign) BOOL                          isContinueCheck;
@property (nonatomic, assign) BOOL                          isOverLength;

@property (nonatomic, copy) AddressEditLandmarkCheckErrorCompletionHandler       addressEditLandmarkCheckErrorCompletionHandler;
@property (nonatomic, copy) AddressEditLandmarkCancelOverLengthCompletionHandler addressEditLandmarkCancelOverLengthCompletionHandler;
@end
