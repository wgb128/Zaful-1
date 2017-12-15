//
//  HomeAndCategoryCell.h
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface HomeAndCategoryCell : UICollectionViewCell

+ (HomeAndCategoryCell *)homeAndCategoryCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath  forRow:(NSInteger)row;

@property (nonatomic, strong) GoodsModel * goodsModel;
@property (nonatomic, strong) void(^goodsClick)(GoodsModel * goodsModel);

@end
