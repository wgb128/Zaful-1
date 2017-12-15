//
//  CategoryRefineInfoView.h
//  ListPageViewController
//
//  Created by TsangFa on 30/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryRefineSectionModel;

typedef void(^ApplyRefineSelectInfoCompletionHandler)(NSDictionary *parms);

@interface CategoryRefineInfoView : UIView

@property (nonatomic, strong) CategoryRefineSectionModel   *model;

@property (nonatomic, copy) ApplyRefineSelectInfoCompletionHandler      applyRefineSelectInfoCompletionHandler;


- (void)clearRequestParmaters;

@end
