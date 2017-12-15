//
//  HomeBannerCell.h
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BannerModel.h"

@interface HomeBannerCell : UICollectionViewCell
+ (HomeBannerCell *)homeBannerCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray * bannerModelArray;

/** 点击最上面的banner回调*/
@property (nonatomic, copy) void(^homeBannerClick)(BannerModel *headModel);

@end

