//
//  ZFCommunityDetailViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCommunityDetailViewModel : BaseViewModel



//评论列表
- (void)requestReviewsListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//回复评论
- (void)requestReplyNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//删除
- (void)requestDeleteNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
