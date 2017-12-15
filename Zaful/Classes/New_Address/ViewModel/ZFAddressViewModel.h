//
//  ZFAddressViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFAddressViewModel : BaseViewModel
//请求地址列表
- (void)requestAddressListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//删除地址
- (void)requestDeleteAddressNetwork:(NSString *)addressId completion:(void (^)(BOOL isOK))completion;

//选择默认地址
- (void)requestsetDefaultAddressNetwork:(NSString *)addressId completion:(void (^)(BOOL isOK))completion;
@end
