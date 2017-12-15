//
//  ZFGoodsReviewsApi.h
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFGoodsReviewsApi : SYBaseRequest
- (instancetype)initWithGoodsID:(NSString *)goodsID goodsSn:(NSString *)goodsSn page:(NSString *)page;

@end
