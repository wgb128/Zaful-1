//
//  HotVideoCell.h
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotVideoCell : UICollectionViewCell

+ (HotVideoCell *)hotVideoCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSDictionary *data;

@end
