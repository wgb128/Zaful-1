//
//  FastSettleApi.h
//  Zaful
//
//  Created by zhaowei on 2017/4/18.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface FastSettleApi : SYBaseRequest
-(instancetype)initWithPayertoken:(NSString *)payertoken payerId:(NSString *)payerId;
@end
