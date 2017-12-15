//
//  ZFGoodsDetailViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFGoodsDetailViewModel : BaseViewModel
/**
 * 取消收藏
 */
- (void)requestDeleteGoodsNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 * 添加收藏
 */
- (void)requestCollectionGoodsNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 * 加入购物车
 */
- (void)requestAddToBagNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
