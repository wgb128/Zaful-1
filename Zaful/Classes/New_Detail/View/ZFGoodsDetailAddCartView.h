//
//  ZFGoodsDetailAddCartView.h
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
typedef void(^CartButtonCompletionHandler)(void);
typedef void(^AddCartButtonCompletionHandler)(void);

@interface ZFGoodsDetailAddCartView : UIView

@property (nonatomic, strong) GoodsDetailModel                  *model;

@property (nonatomic, copy) CartButtonCompletionHandler         cartButtonCompletionHandler;
@property (nonatomic, copy) AddCartButtonCompletionHandler      addCartButtonCompletionHandler;

- (void)changeCartNumberInfo;
@end
