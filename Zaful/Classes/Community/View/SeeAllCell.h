//
//  SeeAllCell.h
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAllCell : UICollectionViewCell

+ (SeeAllCell *)seeAllCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,copy) void (^seeAllBlock)();

@end
