//
//  ZFGoodsDetailSizeSelectView.h
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
typedef void(^GoodsDetailSizeSelectCompletionHandler)(void);

@interface ZFGoodsDetailSizeSelectView : UITableViewHeaderFooterView

@property (nonatomic, strong) GoodsDetailModel          *model;

@property (nonatomic, copy) GoodsDetailSizeSelectCompletionHandler      goodsDetailSizeSelectCompletionHandler;
@end
