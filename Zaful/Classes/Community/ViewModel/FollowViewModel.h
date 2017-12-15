//
//  FollowViewModel.h
//  Buyyer
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 Globalegrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import <UIKit/UIKit.h>

@interface FollowViewModel : BaseViewModel <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) ZFUserListType userListType;
@property (nonatomic, copy  ) NSString       *rid;// 评论ID
@property (nonatomic, copy)   NSString       *userId;

- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
