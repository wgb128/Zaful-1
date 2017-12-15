//
//  ZFAddressAddApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFAddressAddApi : SYBaseRequest
- (instancetype)initWithDic:(NSDictionary *)addressDic;
@end
