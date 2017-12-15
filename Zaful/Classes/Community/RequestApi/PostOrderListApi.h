//
//  PostOrderListApi.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface PostOrderListApi : SYBaseRequest

- (instancetype)initWithOrderWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;

@end
