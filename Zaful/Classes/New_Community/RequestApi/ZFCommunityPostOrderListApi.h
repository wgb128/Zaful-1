//
//  ZFCommunityPostOrderListApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityPostOrderListApi : SYBaseRequest

- (instancetype)initWithOrderWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;

@end
