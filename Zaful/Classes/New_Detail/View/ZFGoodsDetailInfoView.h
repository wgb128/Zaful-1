//
//  ZFGoodsDetailInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
typedef void(^GoodsDetailCollectionCompletionHandler)(BOOL collect);

@interface ZFGoodsDetailInfoView : UITableViewHeaderFooterView

@property (nonatomic, strong) GoodsDetailModel          *model;

@property (nonatomic, copy) GoodsDetailCollectionCompletionHandler          goodsDetailCollectionCompletionHandler;
@end
