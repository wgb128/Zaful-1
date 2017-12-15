//
//  ZFCartDeleteGoodsApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCartDeleteGoodsApi : SYBaseRequest
- (instancetype)initWithGoodsId:(NSArray *)goodsId;

@end
