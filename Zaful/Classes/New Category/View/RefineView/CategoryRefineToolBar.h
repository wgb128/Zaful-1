//
//  CategoryRefineToolBar.h
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearButtonActionCompletionHandle)(void);
typedef void(^ApplyButtonActionCompletionHandle)(void);

@interface CategoryRefineToolBar : UIView

@property (nonatomic, copy) ClearButtonActionCompletionHandle       clearButtonActionCompletionHandle;
@property (nonatomic, copy) ApplyButtonActionCompletionHandle       applyButtonActionCompletionHandle;

@end
