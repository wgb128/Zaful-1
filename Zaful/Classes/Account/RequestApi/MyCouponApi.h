//
//  MyCouponApi.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/11.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SYBaseRequest.h"

@interface MyCouponApi : SYBaseRequest

-(instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;

@end
