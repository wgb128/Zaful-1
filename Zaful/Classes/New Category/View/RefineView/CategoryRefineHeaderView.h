//
//  CategoryRefineHeaderView.h
//  ListPageViewController
//
//  Created by TsangFa on 3/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryRefineDetailModel;

typedef void(^DidSelectRefineSelectInfoViewCompletionHandler)(CategoryRefineDetailModel *model);

@interface CategoryRefineHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) DidSelectRefineSelectInfoViewCompletionHandler  didSelectRefineSelectInfoViewCompletionHandler;

@property (nonatomic, strong) CategoryRefineDetailModel   *model;

+ (NSString *)setIdentifier;

@end
