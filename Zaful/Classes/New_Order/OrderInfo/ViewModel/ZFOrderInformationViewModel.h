//
//  ZFOrderInformationViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFOrderCheckInfoModel;
@class ZFOrderCheckDoneModel;
@class ZFOrderManager;
@class ZFOrderCheckInfoDetailModel;
@class ZFAddressInfoModel;

@interface ZFOrderInformationViewModel : NSObject

/**
 * 获取上传done 接口 参数
 */
- (NSDictionary *)queryCheckDonePublicParmas:(ZFOrderManager *)manager;

/**
 * 获取拆单模式下更改地址后接口请求参数集
 */
- (NSArray *)queryCheckInfoRequestParmasWithPayCode:(NSInteger)paycode managerArray:(NSArray *)managerArray;

/**
 * 获取拆单模式下生成订单信息接口请求参数集
 */
- (NSArray *)queryCheckDoneRequestParmasWithPayCode:(NSInteger)paycode managerArray:(NSArray *)managerArray;

/**
 * 获取订单信息  chekout_info接口
 */
- (void)requestCheckInfoNetwork:(id)parmaters completion:(void (^)(NSArray<ZFOrderCheckInfoModel *>* dataArray))completion failure:(void (^)(id))failure;

/**
 * 生成订单信息  Done接口
 */
- (void)requestCheckDoneOrder:(id)parmaters completion:(void (^)(NSArray<ZFOrderCheckDoneModel *> *dataArray))completion failure:(void (^)(id))failure;

/**
 * 选择支付流程 1 老的   2 新的 拆单
 */
- (void)requestPaymentProcessCompletion:(void (^)(NSInteger state))completion failure:(void (^)(id obj))failure;

/**
 * 请求所有 coupon
 */
- (void)requestAllCouponsNetworkCompletion:(void (^)(NSArray *couponsArray))completion;

/**
 * 验证 coupon 有效性  成功重新请求订单数据  失败就提示
 */
- (void)checkEffectiveCoupon:(NSString *)couponCode parmas:(NSDictionary *)parmas completion:(void (^)(id obj))completion failure:(void (^)())failure;

/**
 * 发送cod手机验证码
 */
- (void)sendPhoneCod:(NSString *)addressID completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

/**
 * 请求购物车数字
 */
- (void)requestCartBadgeNum;

@end
