//
//  ZFCartPriceOptionView.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCartListResultModel;

typedef void(^CartSelctAllGoodsCompletionHandler)(BOOL isSelect);

@interface ZFCartPriceOptionView : UIView

@property (nonatomic, strong) ZFCartListResultModel                     *model;

@property (nonatomic, copy) CartSelctAllGoodsCompletionHandler          cartSelctAllGoodsCompletionHandler;
@end
