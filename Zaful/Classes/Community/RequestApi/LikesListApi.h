//
//  LikesListApi.h
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface LikesListApi : SYBaseRequest

- (instancetype)initWithRid:(NSString *)rid curPage:(NSString *)curPage userId:(NSString *)userId;

@end
