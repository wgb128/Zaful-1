//
//  CategorySubCell.h
//  ListPageViewController
//
//  Created by TsangFa on 6/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryNewModel.h"

typedef void(^CategorySubCellTouchHandler)(BOOL isChoose);

@interface CategorySubCell : UITableViewCell

@property (nonatomic, strong,readonly)  YYLabel          *titleLabel;
@property (nonatomic, assign) BOOL       isSelect;

@property (nonatomic, copy) CategorySubCellTouchHandler   categorySubCellTouchHandler;

+ (NSString *)setIdentifier;

@end
