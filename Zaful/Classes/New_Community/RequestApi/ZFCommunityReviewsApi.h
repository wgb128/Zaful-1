//
//  ZFCommunityReviewsApi.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityReviewsApi : SYBaseRequest

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize reviewId:(NSString *)reviewId;

@end
