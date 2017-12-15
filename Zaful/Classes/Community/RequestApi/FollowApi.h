//
//  FollowApi.h
//  Yoshop
//
//  Created by Stone on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface FollowApi : SYBaseRequest

- (instancetype)initWithFollowStatue:(NSInteger)followStatue followedUserId:(NSString *)followedUserId;

@end
