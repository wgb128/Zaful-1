//
//  CategoryRefineView.h
//  ListPageViewController
//
//  Created by TsangFa on 29/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryRefineSectionModel;

typedef void(^HideRefineViewCompletionHandler)();

typedef void(^ApplyRefineContainerViewInfoCompletionHandler)(NSDictionary *parms);

@interface CategoryRefineContainerView : UIView

@property (nonatomic, copy) HideRefineViewCompletionHandler   hideRefineViewCompletionHandler;

@property (nonatomic, copy) ApplyRefineContainerViewInfoCompletionHandler   applyRefineContainerViewInfoCompletionHandler;

@property (nonatomic, strong) CategoryRefineSectionModel   *model;

- (void)showRefineInfoViewWithAnimation:(BOOL)animation;

- (void)hideRefineInfoViewViewWithAnimation:(BOOL)animation;

- (void)clearRefineInfoViewData;

@end
