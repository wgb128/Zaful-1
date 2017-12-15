//
//  CartOrderInfoDRewardsCell.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"

typedef void (^RefreshRewardsBlock) (NSString *savePrice,NSString *pointNum);

@interface CartOrderInfoDRewardsCell : UITableViewCell

+ (CartOrderInfoDRewardsCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) PointModel *pointModel;

@property (nonatomic, strong) CustomTextField *rewardTextField;
@property (nonatomic, copy) RefreshRewardsBlock refreshRewardBlock;

@end
