//
//  ZFAnalytics.h
//  Zaful
//
//  Created by zhaowei on 2016/10/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyOrdersModel,GoodsDetailModel,GoodsModel,GoodListModel,MyOrderGoodListModel,OrderDetailOrderModel,ZFOrderCheckDoneDetailModel,ZFCollectionModel,CommendModel,CategoryGoodsModel, ZFCartGoodsModel;

@interface ZFAnalytics : NSObject

#pragma -AppsFlyerAnalytics
/**
 *  事件统计量
 *
 *  @param
 */
+ (void)appsFlyerTrackEventWithContentType:(NSString *)contentType;
/**
 *  事件统计量
 *
 *  @param
 */
+ (void)appsFlyerTrackEvent:(NSString *)eventName withValues:(NSDictionary *)values;

/**
 *  付款订单统计量
 *
 *  @param
 */
+ (void)appsFlyerTrackFinishOrderSn:(NSString *)orderSn orderRealPay:(NSString *)orderRealPay goodsIds:(NSString *)goodsIds payMethod:(NSString *)payMethod;

#pragma -googleAnalyticsV3Enabled
/**
 *  屏幕浏览量
 */
+ (void)screenViewQuantityWithScreenName:(NSString *)screenName;

/**
 *  站内广告展示
 */
+ (void)showAdvertisementWithBanners:(NSArray *)banners position:(NSString *)position screenName:(NSString *)screenName;

/**
 *  站内广告点击
 */
+ (void)clickAdvertisementWithId:(NSString *)pid name:(NSString *)name position:(NSString *)position;

/**
 *  产品展示
 */
+ (void)showProductsWithProducts:(NSArray *)products position:(int)position impressionList:(NSString *)impressionList screenName:(NSString *)screenName event:(NSString *)event;

/**
 *  产品展示--商品详情推荐商品
 */
+ (void)showDetailProductsWithProducts:(NSArray *)products position:(int)position impressionList:(NSString *)impressionList screenName:(NSString *)screenName event:(NSString *)event;

/**
 *  产品展示--收藏商品列表
 */
+ (void)showCollectionProductsWithProducts:(NSArray *)products position:(int)position impressionList:(NSString *)impressionList screenName:(NSString *)screenName event:(NSString *)event;

/**
 *  产品点击
 */
+ (void)clickProductWithProduct:(GoodsModel *)product position:(int)position actionList:(NSString *)actionList;

/**
 *  产品点击-收藏
 */
+ (void)clickCollectionProductWithProduct:(ZFCollectionModel *)product position:(int)position actionList:(NSString *)actionList;

/**
 *  产品点击-最近浏览
 */
+ (void)clickHistoryProductWithProduct:(CommendModel *)product position:(int)position actionList:(NSString *)actionList;

/**
 *  产品详情浏览
 */
+ (void)scanProductDetailWithProduct:(GoodsDetailModel *)product screenName:(NSString *)screenName;

/**
 *  结账流程--订单详情
 */
+ (void)settleInfoProcedureWithProduct:(NSArray *)goodsList step:(int)step option:(NSString *)option screenName:(NSString *)screenName;

/**
 *  结账流程--帐号中心
 */
+ (void)settleAccountProcedureWithProduct:(NSArray *)goodsList step:(int)step option:(NSString *)option screenName:(NSString *)screenName;

/**
 *  结账流程--订单详情-订单详情
 */
+ (void)settleAccountInfoProcedureWithProduct:(NSArray *)goodsList step:(int)step option:(NSString *)option screenName:(NSString *)screenName;
/**
 *  结账流程选项
 */
+ (void)optionAccountProcedureWithStep:(int)step option:(NSString *)option;

/**
 *  交易--详情
 */
+ (void)trasactionInfoWithProduct:(NSArray *)products order:(ZFOrderCheckDoneDetailModel *)order screenName:(NSString *)screenName;

/**
 *  交易--个人中心
 */
+ (void)trasactionAccountWithProduct:(MyOrdersModel *)order screenName:(NSString *)screenName;

/**
 *  交易--个人中心--详情
 */
+ (void)trasactionAccountInfoWithProduct:(NSArray *)products order:(OrderDetailOrderModel *)order screenName:(NSString *)screenName;

/**
 *  添加购物车
 */
+ (void)addToCartWithProduct:(GoodsDetailModel *)product fromProduct:(BOOL)isFromProduct;

/**
 *  移除购物车
 */
+ (void)removeFromCartWithItem:(ZFCartGoodsModel *)cartItem;

/**
 *  错误统计
 */
+ (void)statisticException:(NSException *)exc;

/**
 *  按钮点击事件统计
 *  @param vcName       界面名字
 *  @param actionName   按钮事件名字
 *  @param lab          标签名字
 */
+ (void)clickButtonWithCategory:(NSString *)category actionName:(NSString *)actionName label:(NSString*)label;

+(void)logSpeedWithCategory:(NSString *)cateName eventName:(NSString*)name interval:(NSTimeInterval)interval label:(NSString*)label;

+ (void)clickCategoryProductWithProduct:(CategoryGoodsModel *)product position:(int)position actionList:(NSString *)actionList;

+ (void)showCategoryProductsWithProducts:(NSArray *)products position:(int)position impressionList:(NSString *)impressionList screenName:(NSString *)screenName event:(NSString *)event;

+ (void)showSearchProductsWithProducts:(NSArray *)products position:(int)position impressionList:(NSString *)impressionList screenName:(NSString *)screenName event:(NSString *)event;


@end

