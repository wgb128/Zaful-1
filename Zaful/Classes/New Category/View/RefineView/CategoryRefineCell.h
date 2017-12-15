//
//  CategoryRefineCell.h
//  ListPageViewController
//
//  Created by TsangFa on 3/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryRefineCellModel;

typedef void(^ChooseRefineInfoCompletionHandler)(CategoryRefineCellModel   *model);

@interface CategoryRefineCell : UITableViewCell

+ (NSString *)setIdentifier;

@property (nonatomic, assign) BOOL       isSelect;

@property (nonatomic,strong,readonly)  YYLabel           *titleLabel;

@property (nonatomic, copy) ChooseRefineInfoCompletionHandler   chooseRefineInfoCompletionHandler;

@end
