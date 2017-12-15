//
//  ZFCommunityFriendsResultApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityFriendsResultApi : SYBaseRequest

- (instancetype)initWithkeyWord:(NSString *)keyWord andCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize;

@end
