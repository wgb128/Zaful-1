//
//  AccountCancelMyOrdersApi.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/16.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface AccountCancelMyOrdersApi : SYBaseRequest
- (instancetype)initWithOrderId:(NSString*)orderId;
@end
