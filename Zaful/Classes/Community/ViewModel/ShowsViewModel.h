//
//  ShowsViewModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShowsViewModel : BaseViewModel<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//点赞
- (void)requestLikeNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
//删除
- (void)requestDeleteNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
