//
//  ZFCommunityStyleLikesApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityStyleLikesApi : SYBaseRequest
- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage;
@end
