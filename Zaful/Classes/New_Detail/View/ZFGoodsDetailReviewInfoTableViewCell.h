//
//  ZFGoodsDetailReviewInfoTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailFirstReviewModel.h"

typedef void(^GoodsDetailReviewImageCheckCompletionHandler)(NSInteger index);

@interface ZFGoodsDetailReviewInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL                              isTimeStamp;
@property (nonatomic, strong) GoodsDetailFirstReviewModel       *model;

@property (nonatomic, copy) GoodsDetailReviewImageCheckCompletionHandler            goodsDetailReviewImageCheckCompletionHandler;
@end
