//
//  PostGoodsCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFCollectionModel.h"

typedef void(^WishlistSelectBlock)(UIButton *btn);

@interface PostGoodsCell : UITableViewCell

@property (nonatomic,copy) WishlistSelectBlock wishlistSelectBlock;

@property (nonatomic, strong) ZFCollectionModel *goodsListModel;

+ (PostGoodsCell *)postGoodsCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
