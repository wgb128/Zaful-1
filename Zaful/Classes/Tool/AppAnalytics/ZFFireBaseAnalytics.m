//
//  ZFFireBaseAnalytics.m
//  Zaful
//
//  Created by QianHan on 2017/11/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFFireBaseAnalytics.h"

#import <Firebase/Firebase.h>
#import <FirebaseAnalytics/FIREventNames.h>
#import <FirebaseAnalytics/FIRParameterNames.h>

#import "GoodsDetailModel.h"
#import "ZFOrderCheckDoneDetailModel.h"
#import "ZFOrderCheckInfoDetailModel.h"

@implementation ZFFireBaseAnalytics

+ (void)screenRecordWithName:(nonnull NSString *)screenName screenClass:(nullable NSString *)screenClass {
    [FIRAnalytics setScreenName:screenName screenClass:screenClass];
}

+ (void)appOpen {
    [FIRAnalytics logEventWithName:kFIREventAppOpen parameters:nil];
}

+ (void)addPaymentInfo {
    [FIRAnalytics logEventWithName:kFIREventAddPaymentInfo parameters:nil];
}

+ (void)scanGoodsWithGoodsModel:(GoodsDetailModel *)goodsModel {
   
    [FIRAnalytics logEventWithName:kFIREventViewItem
                        parameters:@{
                                     kFIRParameterItemID: [ZFFireBaseAnalytics filterString:goodsModel.goods_id],
                                     kFIRParameterItemName: [ZFFireBaseAnalytics filterString:goodsModel.goods_name],
                                     kFIRParameterItemCategory: [ZFFireBaseAnalytics filterString:goodsModel.long_cat_name]
                                     }];
}

+ (void)scanGoodsListWithCategory:(NSString *)categaory {
    [FIRAnalytics logEventWithName:kFIREventViewItemList
                        parameters:@{
                                     kFIRParameterItemCategory: [ZFFireBaseAnalytics filterString:categaory]
                                     }];
}

+ (void)searchResultWithTerm:(NSString *)term {
    
    [FIRAnalytics logEventWithName:kFIREventViewSearchResults
                        parameters:@{
                                     kFIRParameterSearchTerm: [ZFFireBaseAnalytics filterString:term]
                                     }];
}

+ (void)addToCartWithGoodsModel:(GoodsDetailModel *)goodsModel {
    [FIRAnalytics logEventWithName:kFIREventAddToCart
                        parameters:@{
                                     kFIRParameterItemID: [ZFFireBaseAnalytics filterString:goodsModel.goods_id],
                                     kFIRParameterItemName: [ZFFireBaseAnalytics filterString:goodsModel.goods_name],
                                     kFIRParameterItemCategory: [ZFFireBaseAnalytics filterString:goodsModel.long_cat_name],
                                     kFIRParameterQuantity: @"1"
                                     }];
}

+ (void)addCollectionWithGoodsModel:(GoodsDetailModel *)goodsModel {
    [FIRAnalytics logEventWithName:kFIREventAddToWishlist
                        parameters:@{
                                     kFIRParameterItemID: [ZFFireBaseAnalytics filterString:goodsModel.goods_id],
                                     kFIRParameterItemName: [ZFFireBaseAnalytics filterString:goodsModel.goods_name],
                                     kFIRParameterItemCategory: [ZFFireBaseAnalytics filterString:goodsModel.long_cat_name],
                                     kFIRParameterQuantity: @"1"
                                     }];
}

+ (void)beginCheckOutWithGoodsInfo:(nullable ZFOrderCheckInfoDetailModel *)goodsInfo {
    NSString *currency = [ExchangeManager localCurrency];
    if (goodsInfo == nil) {
        [FIRAnalytics logEventWithName:kFIREventBeginCheckout
                            parameters:nil];
    } else {
        [FIRAnalytics logEventWithName:kFIREventBeginCheckout
                            parameters:@{
                                         kFIRParameterCurrency: currency,
                                         kFIRParameterValue: [ZFFireBaseAnalytics filterString:goodsInfo.total.goods_price],
                                         kFIRParameterCoupon: [ZFFireBaseAnalytics filterString:goodsInfo.total.coupon_code]
                                         }];
    }
}

+ (void)finishedPurchaseWithOrderModel:(ZFOrderCheckDoneDetailModel *)orderModel {
    NSString *currency = [ExchangeManager localCurrency];
    [FIRAnalytics logEventWithName:kFIREventEcommercePurchase
                        parameters:@{
                                     kFIRParameterTransactionID: [ZFFireBaseAnalytics filterString:orderModel.order_sn],
                                     kFIRParameterValue: [ZFFireBaseAnalytics filterString:orderModel.order_amount],
                                     kFIRParameterShipping: [ZFFireBaseAnalytics filterString:orderModel.shipping_fee],
                                     kFIRParameterCurrency: currency
                                     }];
}

+ (void)signUpWithType:(NSString *)typeName {
    [FIRAnalytics logEventWithName:kFIREventSignUp
                        parameters:@{
                                     kFIRParameterSignUpMethod: typeName
                                     }];
}

+ (void)signInWithTypeName:(NSString *)typeName {
    [FIRAnalytics logEventWithName:kFIREventLogin
                        parameters:@{
                                     kFIRParameterSignUpMethod: typeName
                                     }];
}

+ (void)selectContentWithItemId:(NSString *)itemId
                       itemName:(NSString *)itemName
                    ContentType:(NSString *)contentType
                   itemCategory:(NSString *)category {
    itemId = [ZFFireBaseAnalytics filterString:itemId];
    itemName = [ZFFireBaseAnalytics filterString:itemName];
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID: itemId,
                                     kFIRParameterItemName: itemName.length > 0 ? itemName : @"",
                                     kFIRParameterContentType: contentType,
                                     kFIRParameterItemCategory: category.length > 0 ? category : @""
                                     }];
}
    
+ (void)checkoutProgressWithStep:(NSInteger)step checkInfoModel:(ZFOrderCheckInfoDetailModel *)checkInfoModel {
    [FIRAnalytics logEventWithName:kFIREventCheckoutProgress
                        parameters:@{
                                     kFIRParameterCheckoutStep: [NSString stringWithFormat:@"%ld", (long)step],
                                     kFIRParameterContentType: @"OrderDetail",
                                     kFIRParameterPrice: [ZFFireBaseAnalytics filterString:checkInfoModel.total.goods_price],
                                     kFIRParameterCoupon: [ZFFireBaseAnalytics filterString:checkInfoModel.total.coupon_code],
                                     kFIRParameterCurrency: [ExchangeManager localCurrency]
                                     }];
}

// 过滤特殊字符，不然统计闪退（数据库不能保存特殊字符）
+ (NSString *)filterString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]
        || [string length] == 0) {
        return @"";
    }
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）「」＂、[]{}#%*+=\\|~＜＞^•'@#%^&*()+'\""];
    NSString *resultString = [[string componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    return resultString;
}

@end
