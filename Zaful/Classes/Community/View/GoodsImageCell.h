//
//  GoodsImageCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectGoodsModel.h"

typedef void(^DeleteGoodsBlock)(SelectGoodsModel *model);

@interface GoodsImageCell : UICollectionViewCell

@property (nonatomic, copy) DeleteGoodsBlock deleteGoodBlock;

@property (nonatomic, strong) SelectGoodsModel *model;

@property (nonatomic, strong) UIImage *goodsImage;

@property (nonatomic,assign) BOOL isNeedHiddenAddView;

+ (GoodsImageCell *)goodsImageCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
