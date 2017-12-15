//
//  PostViewModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface PostViewModel : BaseViewModel
- (void)requestTabObtainNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
- (void)requestPostNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
