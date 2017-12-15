 //
//  FollowItemCell.h
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowItemModel.h"

typedef void(^FollowBlock)(void);

@interface FollowItemCell : UITableViewCell

@property (nonatomic, copy) FollowBlock block;

+ (FollowItemCell *)followItemCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

- (void)configCellWithFollowItemModel:(FollowItemModel *)model indexPath:(NSIndexPath *)indexPath;

@end
