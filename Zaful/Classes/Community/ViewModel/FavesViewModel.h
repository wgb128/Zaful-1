//
//  FavesViewModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

typedef void(^RewardPikerBlock)(NSInteger);

@interface FavesViewModel : BaseViewModel<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,weak) UIViewController *controller;
@property (nonatomic,copy) RewardPikerBlock rewardBlock;
@property (nonatomic,strong) NSMutableArray *dataArray;

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
