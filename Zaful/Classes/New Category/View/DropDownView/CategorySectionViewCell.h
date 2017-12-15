//
//  CategorySectionView.h
//  ListPageViewController
//
//  Created by TsangFa on 6/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryNewModel;

typedef void(^CategorySectionViewTouchHandler)(CategoryNewModel *model);

@interface CategorySectionViewCell : UITableViewHeaderFooterView

@property (nonatomic, strong) CategoryNewModel   *model;

@property (nonatomic, copy) CategorySectionViewTouchHandler   categorySectionViewTouchHandler;

+ (NSString *)setIdentifier;

@end
