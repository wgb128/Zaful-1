//
//  ZFGoodsDetailApi.h
//  Zaful
//
//  Created by liuxi on 2017/11/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFGoodsDetailApi : SYBaseRequest
- (instancetype)initWithGoodsDetialUserId:(NSString *)userId goodsId:(NSString *)goodsId;
@end
