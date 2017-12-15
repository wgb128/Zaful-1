//
//  LabelDetailViewModel.h
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface LabelDetailViewModel : BaseViewModel<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *labelName;

- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
//关注
- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
