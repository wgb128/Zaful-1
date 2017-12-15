//
//  TopicViewModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface TopicViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) void (^topicclickEventBlock)(NSInteger sort);
@property (nonatomic, strong) NSMutableArray *dataArray;
//评论列表
- (void)requestTopicDetailListNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

- (void)isHiddenEmpty:(BOOL)isShow;

@end
