//
//  MyStylePageViewModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/8/19.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyStylePageViewModel : BaseViewModel

- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

@end
