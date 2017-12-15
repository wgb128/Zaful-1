//
//  PostBagCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodListModel.h"

typedef void(^BagSelectBlock)(UIButton *button);

@interface PostBagCell : UITableViewCell

@property (nonatomic,copy) BagSelectBlock bagSelectBlock;

@property (nonatomic,strong) GoodListModel *goodListModel;

+ (PostBagCell *)postBagCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
