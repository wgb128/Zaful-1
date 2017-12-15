//
//  PostPhotoCell.h
//  Zaful
//
//  Created by TsangFa on 16/11/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeletePhotoBlock)(UIImage *photo);

@interface PostPhotoCell : UICollectionViewCell

@property (nonatomic,copy) DeletePhotoBlock deletePhotoBlock;

@property (nonatomic,strong) UIImage *photo;

@property (nonatomic,assign) BOOL isNeedHiddenAddView;

+ (PostPhotoCell *)postPhotoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
