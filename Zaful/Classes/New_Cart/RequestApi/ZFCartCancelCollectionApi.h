//
//  ZFCartCancelCollectionApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCartCancelCollectionApi : SYBaseRequest

- (instancetype)initWithGoodsId:(NSString *)goodsId;

@end
