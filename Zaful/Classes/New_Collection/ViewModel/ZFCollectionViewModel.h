//
//  ZFCollectionViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCollectionViewModel : BaseViewModel

/**
 *收藏列表
 */
- (void)requestCollectionNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 *取消收藏
 */
- (void)requestDeleteCollectionNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
