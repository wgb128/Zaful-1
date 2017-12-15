//
//  HomeCategoryCell.h
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@interface HomeCategoryCell : UICollectionViewCell
+ (HomeCategoryCell *)homeCategoryCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) BannerModel * homeCategoryBanner;

@property (nonatomic, copy) void(^homeCategoryBannerClick)(BannerModel *categoryModel);


@end
