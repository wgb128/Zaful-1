//
//  ZFPaymentGoodsInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckOutGoodListModel;

@interface ZFPaymentGoodsInfoView : UIView
@property (nonatomic, strong) NSArray<CheckOutGoodListModel *>            *dataArray;
@end
