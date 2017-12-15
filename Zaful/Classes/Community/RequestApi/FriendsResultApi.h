//
//  FriendsResultApi.h
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface FriendsResultApi : SYBaseRequest

- (instancetype)initWithkeyWord:(NSString *)keyWord andCurPage:(NSInteger)curPage pageSize:(NSInteger)pageSize;

@end
