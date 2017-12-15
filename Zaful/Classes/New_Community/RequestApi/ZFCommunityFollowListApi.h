//
//  ZFCommunityFollowListApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityFollowListApi : SYBaseRequest

- (instancetype)initWithCurPage:(NSString *)curPage userListType:(ZFUserListType)userListType userId:(NSString *)userId;

@end
