//
//  BagViewModel.h
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface BagViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,weak) UIViewController *controller;

- (void)requestBagNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
