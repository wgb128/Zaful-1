//
//  FollowListApi.h
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface FollowListApi : SYBaseRequest

- (instancetype)initWithCurPage:(NSString *)curPage userListType:(ZFUserListType)userListType userId:(NSString *)userId;

@end
