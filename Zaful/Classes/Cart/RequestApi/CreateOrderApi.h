//
//  CreateOrderApi.h
//  Zaful
//
//  Created by TsangFa on 17/3/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"
#import "OrderInfoManager.h"

@interface CreateOrderApi : SYBaseRequest

- (instancetype)initWithDict:(OrderInfoManager *)manager;

@end
