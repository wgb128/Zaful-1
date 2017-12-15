//
//  ZFGoodsDetailCollectionApi.h
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFGoodsDetailCollectionApi : SYBaseRequest
- (instancetype)initWithAddCollectionGoodsId:(NSString *)goodsId;
@end
