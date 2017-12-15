//
//  PostRecentCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommendModel.h"

typedef void(^RecentSelectBlock)(UIButton *button);

@interface PostRecentCell : UITableViewCell

@property (nonatomic,strong) CommendModel *goodsListModel;

@property (nonatomic,copy) RecentSelectBlock recentSelectBlock;

+ (PostRecentCell *)postRecentCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
