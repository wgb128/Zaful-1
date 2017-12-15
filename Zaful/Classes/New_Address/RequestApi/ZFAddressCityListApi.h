//
//  ZFAddressCityListApi.h
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFAddressCityListApi : SYBaseRequest
- (instancetype)initWithProvinceId:(NSString *)provinceId countryId:(NSString *)countryId;
@end
