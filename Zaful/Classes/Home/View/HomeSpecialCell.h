//
//  HomeSpecialCell.h
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@interface HomeSpecialCell : UICollectionViewCell
+ (HomeSpecialCell *)homeSpecialCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) BannerModel * homeBannerModel;

/** 点击分类的产品*/
@property (nonatomic, copy) void (^specialClick)(BannerModel * homeBannerModel);

@end
