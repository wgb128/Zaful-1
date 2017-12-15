//
//  CartCheckApi.h
//  Yoshop
//
//  Created by zhaowei on 16/6/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@class OrderInfoManager;

@interface CartCheckOutApi : SYBaseRequest
- (instancetype)initWithManager:(OrderInfoManager *)manager;
@end
