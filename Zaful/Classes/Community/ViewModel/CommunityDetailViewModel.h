//
//  CommunityDetailViewModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface CommunityDetailViewModel : BaseViewModel

@property (nonatomic, weak) UIViewController *controller;

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
