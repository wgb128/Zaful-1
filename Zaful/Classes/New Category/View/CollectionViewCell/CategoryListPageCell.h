//
//  ListPageCell.h
//  ListPageViewController
//
//  Created by TsangFa on 19/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryGoodsModel;

@interface CategoryListPageCell : UICollectionViewCell

+ (NSString *)setIdentifier;

@property (nonatomic, strong) CategoryGoodsModel   *model;

@end
