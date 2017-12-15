//
//  ZFCartViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"
@class ZFCartGoodsModel;

@interface ZFCartViewModel : BaseViewModel

/*
 获取购物车列表
 */
- (void)requestCartListNetwork:(id)parmaters completion:(void (^)(id obj))completion  failure:(void (^)(id obj))failure;

/*
 选择商品，刷新购物车列表，串行请求
 */
- (void)requestCartSelectGoodsNetwork:(ZFCartGoodsModel *)model completion:(void (^)(BOOL isOK))completion;

/*
 全选商品，刷新购物车列表，串行请求
 */
- (void)requestCartSelectAllGoodsNetwork:(NSArray *)goods completion:(void (^)(BOOL isOK))completion;

/*
 删除购物车商品,刷新购物车列表，串行请求
 */
- (void)requestCartDelNetwork:(NSString *)goodsId completion:(void (^)(BOOL isOK))completion;

/*
 清空购物车实效商品,刷新购物车列表，串行请求
 */
- (void)requestCartUnavailableClearAllNetwork:(NSArray *)array completion:(void (^)(BOOL isOK))completion;

/*
 添加收藏商品
 */
- (void)requestAddGoodCollectionNetwork:(NSString *)goodId completion:(void (^)(BOOL isOK))completion failure:(void (^)())failure;

/*
 取消收藏商品
 */
- (void)requestCancelGoodCollectionNetwork:(NSString *)goodId completion:(void (^)(BOOL isOK))completion failure:(void (^)())failure;

/*
 改变商品数量, 刷新购物车列表，串行请求
 */
- (void)requestUpdateCartNumNetworkWithNum:(NSInteger)goodNum goodId:(NSString *)goodId completion:(void (^)(BOOL isOK))completion;

/*
 购物车选中商品生成订单
 */
- (void)requestCartCheckOutNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/*
 购物车快捷支付
 */
- (void)requestCartFastPayNetworkWithPayertoken:(NSString *)payertoken payerId:(NSString *)payerId completion:(void (^)(BOOL hasAddress, id obj))completion failure:(void (^)(id obj))failure;

/*
 选择支付流程
 */
- (void)requestPaymentProcessCompletion:(void (^)(NSInteger state))completion failure:(void (^)(id obj))failure;
@end

