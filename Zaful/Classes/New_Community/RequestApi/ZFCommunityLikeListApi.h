//
//  ZFCommunityLikeListApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityLikeListApi : SYBaseRequest

- (instancetype)initWithRid:(NSString *)rid curPage:(NSString *)curPage userId:(NSString *)userId;

@end
