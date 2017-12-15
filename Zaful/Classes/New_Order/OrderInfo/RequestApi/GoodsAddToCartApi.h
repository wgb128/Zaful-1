//
//  GoodsAddCollectApi.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface GoodsAddToCartApi : SYBaseRequest

- (instancetype)initWithGoodsId:(NSString *)goodsId;

@property (nonatomic, strong) NSString *goodsId;

@end
