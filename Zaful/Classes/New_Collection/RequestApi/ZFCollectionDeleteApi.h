//
//  ZFCollectionDeleteApi.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCollectionDeleteApi : SYBaseRequest
- (instancetype)initDeleteCollectionWith:(NSString *)userId goodsId:(NSString *)goodsId;
@end
