//
//  ZFCartSelectGoodsApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCartSelectGoodsApi : SYBaseRequest
- (instancetype)initWithGoodsId:(NSString *)goodsId selectStatus:(NSInteger)isSelected;

- (instancetype)initWithGoodsArray:(NSArray *)goodsArray;
@end
