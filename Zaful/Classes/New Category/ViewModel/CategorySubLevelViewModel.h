//
//  CategorySubLevelViewModel.h
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryNewModel.h"

typedef void(^SubLevelCompletionHandler)(CategoryNewModel *model);

@interface CategorySubLevelViewModel : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, copy) SubLevelCompletionHandler   handler;

- (void)requestSubLevelDataWithParentID:(NSString *)parentID completion:(void (^)())completion;

@end
