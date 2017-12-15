//
//  LikeApi.h
//  Yoshop
//
//  Created by Stone on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYBaseRequest.h"

@interface LikeApi : SYBaseRequest

- (instancetype)initWithReviewId:(NSString *)reviewId flag:(NSInteger)flag;

@end
