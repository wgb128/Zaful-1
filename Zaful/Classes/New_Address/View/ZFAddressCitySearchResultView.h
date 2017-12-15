//
//  ZFAddressCitySearchResultView.h
//  Zaful
//
//  Created by liuxi on 2017/9/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFAddressCityModel;

typedef void(^AddressCitySearchSelectCompletionHandler)(ZFAddressCityModel *model);

@interface ZFAddressCitySearchResultView : UIView
@property (nonatomic, strong) NSMutableArray<ZFAddressCityModel *>    *dataArray;
@property (nonatomic, copy) AddressCitySearchSelectCompletionHandler        addressCitySearchSelectCompletionHandler;
@end
