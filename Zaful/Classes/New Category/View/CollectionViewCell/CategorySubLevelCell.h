//
//  SubLevelCell.h
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryNewModel;

@interface CategorySubLevelCell : UICollectionViewCell

+ (NSString *)setIdentifier;

@property (nonatomic, strong) CategoryNewModel   *model;

@end
