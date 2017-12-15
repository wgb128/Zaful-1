//
//  ParentCell.h
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryNewModel.h"

typedef void(^ParentCellTouchHandler)(CategoryNewModel *model);

@interface CategoryParentCell : UICollectionViewCell

+ (NSString *)setIdentifier;

@property (nonatomic, copy) ParentCellTouchHandler   handler;

@property (nonatomic, strong) CategoryNewModel   *model;

@end
