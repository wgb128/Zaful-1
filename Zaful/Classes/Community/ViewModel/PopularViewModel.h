//
//  PopularViewModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface PopularViewModel : BaseViewModel<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UIViewController *controller;

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
