//
//  ZFCommunityLikeApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityLikeApi : SYBaseRequest
- (instancetype)initWithReviewId:(NSString *)reviewId flag:(NSInteger)flag;
@end
