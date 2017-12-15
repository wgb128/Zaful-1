//
//  ZFCartEditGoodsApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCartEditGoodsApi : SYBaseRequest
- (instancetype)initWithGoodNum:(NSInteger)goodNum GoodId:(NSString *)goodId;
@end
