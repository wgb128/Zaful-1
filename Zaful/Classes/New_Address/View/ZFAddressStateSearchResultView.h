//
//  ZFAddressStateSearchResultView.h
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressStateModel;

typedef void(^AddressStateSearchSelectCompletionHandler)(ZFAddressStateModel *model);

@interface ZFAddressStateSearchResultView : UIView
@property (nonatomic, strong) NSMutableArray<ZFAddressStateModel *>    *dataArray;

@property (nonatomic, copy) AddressStateSearchSelectCompletionHandler       addressStateSearchSelectCompletionHandler;
@end
