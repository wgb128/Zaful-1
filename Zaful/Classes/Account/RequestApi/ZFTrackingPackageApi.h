//
//  ZFTrackingPackageApi.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFTrackingPackageApi : SYBaseRequest

- (instancetype)initWithOrderID:(NSString *)orderID;

@end
