//
//  VideoViewModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface VideoViewModel : BaseViewModel<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UIViewController *controller;

//评论列表
- (void)requestReviewsListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//回复评论
- (void)requestReplyNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
