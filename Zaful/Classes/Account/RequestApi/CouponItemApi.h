//
//  CouponItemApi.h
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface CouponItemApi : SYBaseRequest
-(instancetype)initWithKind:(NSString *)kind page:(NSInteger)page pageSize:(NSInteger)pageSize;
@end
