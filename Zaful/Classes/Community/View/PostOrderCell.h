//
//  OrderCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostOrderListModel.h"

typedef void(^OrderSelectBlock)(UIButton *button);

@interface PostOrderCell : UITableViewCell

@property (nonatomic,copy) OrderSelectBlock orderSelectBlock;

@property (nonatomic, strong) PostOrderListModel *goodsListModel;

+ (PostOrderCell *)postOrderCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
