//
//  LikesViewModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface LikesViewModel : BaseViewModel<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//关注
- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
