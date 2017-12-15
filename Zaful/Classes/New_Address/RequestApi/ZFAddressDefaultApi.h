//
//  ZFAddressDefaultApi.h
//  Zaful
//
//  Created by liuxi on 2017/8/30.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFAddressDefaultApi : SYBaseRequest
- (instancetype)initWithAddressId:(NSString *)addressId;
@end
