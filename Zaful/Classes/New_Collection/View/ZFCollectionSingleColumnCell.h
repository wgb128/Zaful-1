//
//  ZFColleciontSingleColumnCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCollectionModel;

typedef void(^CollectionDelectCompletionHandler)(ZFCollectionModel *model);

@interface ZFCollectionSingleColumnCell : UICollectionViewCell

@property (nonatomic, strong) ZFCollectionModel     *model;

@property (nonatomic, copy) CollectionDelectCompletionHandler       collectionDelectCompletionHandler;
@end
