//
//  ZFGoodsAddToCartApi.h
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFGoodsAddToCartApi : SYBaseRequest

- (instancetype)initWithGoodsId:(NSString *)goodsId goodsNumber:(NSInteger)number;

@end
