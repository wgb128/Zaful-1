//
//  ZFGoodsDetailReviewsHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

typedef void(^GoodsDetailReviewsViewMoreCompletionHandler)(void);

@interface ZFGoodsDetailReviewsHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) GoodsDetailModel          *model;
@property (nonatomic, assign) BOOL                      isOpen;
@property (nonatomic, copy) GoodsDetailReviewsViewMoreCompletionHandler     goodsDetailReviewsViewMoreCompletionHandler;
@end
