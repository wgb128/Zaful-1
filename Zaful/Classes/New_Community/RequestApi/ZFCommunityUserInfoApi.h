//
//  ZFCommunityUserInfoApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityUserInfoApi : SYBaseRequest
- (instancetype)initWithUserid:(NSString *)userid;
@end
