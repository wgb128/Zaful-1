//
//  RecentViewModel.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface RecentViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UIViewController *controller;

- (void)requestRecentNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
