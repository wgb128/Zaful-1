//
//  CategoryParentViewModel.h
//  ListPageViewController
//
//  Created by TsangFa on 26/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryParentCell.h"

typedef void(^ParentCompletionHandler)(CategoryNewModel *model);

@interface CategoryParentViewModel : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, copy) ParentCompletionHandler   handler;

-(void)requestParentsDataCompletion:(void (^)())completion failure:(void (^)(id obj))failure;

@end
