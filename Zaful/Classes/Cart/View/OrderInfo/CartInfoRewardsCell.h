//
//  CartInfoRewardsCell.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"


@interface CartInfoRewardsCell : UITableViewCell

@property (nonatomic,strong) PointModel *model;

@property (nonatomic, copy) void (^inputRewardBlock) (NSString *savePrice,NSString *inputReward) ;

+ (CartInfoRewardsCell *)rewardsCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
