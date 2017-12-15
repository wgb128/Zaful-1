//
//  HomeGoodsHeadView.h
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGoodsHeadView : UICollectionReusableView

@property (nonatomic, strong) UILabel * titleLabel;

+ (HomeGoodsHeadView *)homeGoodsHeadViewWithCollectionView:(UICollectionView *)collectionView Kind:(NSString *)kind IndexPath:(NSIndexPath *)indexPath ;


@end
