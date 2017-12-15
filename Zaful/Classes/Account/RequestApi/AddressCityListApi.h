//
//  AddressCityListApi.h
//  Zaful
//
//  Created by TsangFa on 25/4/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface AddressCityListApi : SYBaseRequest

- (instancetype)initWithProvinceId:(NSString *)provinceId countryId:(NSString *)countryId;
@end
