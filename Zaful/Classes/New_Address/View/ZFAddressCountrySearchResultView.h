//
//  ZFAddressSearchResultView.h
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressCountryModel;

typedef void(^AddressCountryResultSelectCompletionHandler)(ZFAddressCountryModel *model);

@interface ZFAddressCountrySearchResultView : UIView
@property (nonatomic, strong) NSMutableArray<ZFAddressCountryModel *>        *dataArray;

@property (nonatomic, copy) AddressCountryResultSelectCompletionHandler     addressCountryResultSelectCompletionHandler;
@end
