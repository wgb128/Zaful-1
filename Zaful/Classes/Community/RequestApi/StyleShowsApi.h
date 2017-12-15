//
//  StyleShowsApi.h
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface StyleShowsApi : SYBaseRequest
- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage;
@end
