//
//  CommunityDetailApi.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/14.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface CommunityDetailApi : SYBaseRequest

- (instancetype)initWithReviewId:(NSString*)reviewId;

@end
