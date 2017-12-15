//
//  ZFGoodsDetailQualifiedView.h
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

typedef void(^GoodsDetailQualifiedCompletionHandler)(NSString *url);

@interface ZFGoodsDetailQualifiedView : UITableViewHeaderFooterView

@property (nonatomic, strong) GoodsDetailModel          *model;

@property (nonatomic, copy) GoodsDetailQualifiedCompletionHandler       goodsDetailQualifiedCompletionHandler;
@end
