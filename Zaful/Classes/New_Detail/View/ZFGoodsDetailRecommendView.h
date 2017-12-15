//
//  ZFGoodsDetailRecommendView.h
//  Zaful
//
//  Created by liuxi on 2017/11/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailSameModel;

typedef void(^GoodsDetailRecommendSelectCompletionHandler)(NSString *goodsId);

@interface ZFGoodsDetailRecommendView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSArray<GoodsDetailSameModel *>            *dataArray;

@property (nonatomic, copy) GoodsDetailRecommendSelectCompletionHandler     goodsDetailRecommendSelectCompletionHandler;

@end
