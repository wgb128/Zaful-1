//
//  AddressDeleteApi.h
//  Yoshop
//
//  Created by Qiu on 16/6/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface AddressDeleteApi : SYBaseRequest

- (instancetype)initWithDeleteAddressId:(NSString *)addressId;

@end
