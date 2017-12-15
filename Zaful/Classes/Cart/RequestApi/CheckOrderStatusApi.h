//
//  CheckOrderStatusApi.h
//  Zaful
//
//  Created by 7FD75 on 16/9/20.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface CheckOrderStatusApi : SYBaseRequest

-(instancetype)initWithOrderSN:(NSString *)orderSN;

@end
