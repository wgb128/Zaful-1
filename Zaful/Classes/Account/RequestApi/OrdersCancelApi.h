//
//  OrdersCancelApi.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/16.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface OrdersCancelApi : SYBaseRequest
- (instancetype)initWithOrderId:(NSString*)orderId;
@end
