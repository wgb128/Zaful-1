//
//  ZFAddressDeleteApi.h
//  Zaful
//
//  Created by liuxi on 2017/8/30.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFAddressDeleteApi : SYBaseRequest
- (instancetype)initWithDeleteAddressId:(NSString *)addressId;
@end
