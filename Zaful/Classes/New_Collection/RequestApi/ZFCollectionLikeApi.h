//
//  ZFCollectionLikeApi.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCollectionLikeApi : SYBaseRequest
- (instancetype)initWithCollectionWith:(NSString *)userId page:(NSInteger)page pageSize:(NSInteger)pageSize;
@end
