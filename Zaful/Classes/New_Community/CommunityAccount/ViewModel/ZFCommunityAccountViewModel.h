//
//  ZFCommunityAccountViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCommunityAccountViewModel : BaseViewModel

- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

- (void)requestMessageCountNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
