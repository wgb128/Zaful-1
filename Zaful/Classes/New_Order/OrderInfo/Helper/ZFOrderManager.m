//
//  ZFOrderManager.m
//  Zaful
//
//  Created by TsangFa on 27/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderManager.h"
#import "FilterManager.h"
#import "ZFOrderAmountDetailModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "ZFOrderCheckDoneDetailModel.h"
#import "RateModel.h"

@interface ZFOrderManager ()
@property (nonatomic,copy)   NSString                   *codDiscountTitle;
@end

@implementation ZFOrderManager
#pragma mark - Public method
- (void)adapterManagerWithModel:(ZFOrderCheckInfoDetailModel *)checkOutModel {
    
    if ([NSArrayUtils isEmptyArray:checkOutModel.payment_list]) {
        [FilterManager saveTempCOD:NO];
    } else {
        [checkOutModel.payment_list enumerateObjectsUsingBlock:^(PaymentListModel *paymentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([paymentModel.default_select boolValue]) {
                self.currentPaymentType = [paymentModel.pay_code isEqualToString:@"Cod"] ? CurrentPaymentTypeCOD : CurrentPaymentTypeOnline;
                [FilterManager saveTempCOD:[paymentModel.pay_code isEqualToString:@"Cod"] ? YES : NO];
                self.paymentCode    = paymentModel.pay_code;
                self.codFreight     = [paymentModel.pay_code isEqualToString:@"Cod"] ? checkOutModel.cod.codFee : @"0.00";
            }
        }];
    }
    
    //判断是否支持货到付款，把当前国家对应的货币存储到本地临时变量
    NSString *currency = [FilterManager isSupportCOD:checkOutModel.address_info.country_id];
    if (![NSStringUtils isEmptyString:currency]) {
        [FilterManager saveTempFilter:currency];
    }

    self.shippingListArray = [NSMutableArray array];
    [checkOutModel.shipping_list enumerateObjectsUsingBlock:^(ShippingListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.default_select boolValue]) {
            self.shippingId     = model.iD;
            self.shippingPrice  = model.ship_price;
        }
        
        if ([FilterManager tempCOD:self.currentPaymentType == CurrentPaymentTypeCOD]) {
            if ([model.is_cod_ship boolValue]) {
                [self.shippingListArray addObject:model];
            }
        }else if (![model.is_cod_ship boolValue]) {
            [self.shippingListArray addObject:model];
        }
    }];
    
    if ([checkOutModel.point.avail_point floatValue] >= 50) {
        self.currentPoint   = checkOutModel.point.currentPoint;
        self.pointSavePrice = [NSString stringWithFormat:@"%.2f",[checkOutModel.point.currentPoint floatValue] * 0.02];
    }
    
    self.couponCode             = checkOutModel.total.coupon_code;
    self.addressId              = checkOutModel.address_info.address_id;
    self.addressCode            = checkOutModel.address_info.code;
    self.supplierNumber         = checkOutModel.address_info.supplier_number;
    self.tel                    = checkOutModel.address_info.tel;
    self.need_traking_number    = checkOutModel.total.need_traking_number;
    self.insurance              = checkOutModel.ifNeedInsurance ? checkOutModel.total.insure_fee : @"0.00";
    self.goods_price            = checkOutModel.total.goods_price;
    self.couponAmount           = checkOutModel.total.coupon_amount;
    self.countryID              = checkOutModel.address_info.country_id;
    self.activities_amount      = checkOutModel.total.activities_amount;
    //用于快速支付
    self.payertoken             = checkOutModel.payertoken;
    self.payerId                = checkOutModel.payerId;
    self.codDiscountTitle       = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Discount",nil);
}

- (NSMutableArray *)queryAmountDetailArray {
    NSDictionary *dict = @{
                           ZFLocalizedString(@"MyOrders_Cell_Total",nil)                                : [self querySubtotal],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingCost",nil)         : [self queryShippingCost],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingInsurance",nil)    : [self queryShippingInsurance],
                           ZFLocalizedString(@"OrderInfoViewModel_COD_cost", nil)                       : [self queryCodCost],
                           ZFLocalizedString(@"ZFOrderEvent", nil)                                      : [self querySalesEvents],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil)  : [self queryCouponSaving],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil)        : [self queryZPointsSaving],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_GrandTotal",nil)           : [self queryGrandTotal],
                           ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil)         : [self queryTotalPayable]
                           };

    NSMutableDictionary *amountDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString *codDiscount = [self queryCodDiscount];
    [amountDict setObject:codDiscount forKey:self.codDiscountTitle];
    
    NSMutableArray *amountKeyArray = [NSMutableArray arrayWithObjects:ZFLocalizedString(@"MyOrders_Cell_Total",nil),
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingCost",nil),
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingInsurance",nil),
                       ZFLocalizedString(@"OrderInfoViewModel_COD_cost", nil),
                       ZFLocalizedString(@"ZFOrderEvent", nil),
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil),
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil),
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_GrandTotal",nil),
                       self.codDiscountTitle,
                       ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil),
                       nil];

    if ([self.activities_amount floatValue] == 0) {
        [amountKeyArray removeObject:ZFLocalizedString(@"ZFOrderEvent", nil)];
        [amountDict removeObjectForKey:ZFLocalizedString(@"ZFOrderEvent", nil)];
    }
    
    if ([self.couponAmount floatValue] == 0) {
        [amountKeyArray removeObject: ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil)];
        [amountDict removeObjectForKey: ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil)];
    }
    
    if ([self.pointSavePrice floatValue] == 0) {
        [amountKeyArray removeObject:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil)];
        [amountDict removeObjectForKey:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil)];
    }
    
    if (self.currentPaymentType == CurrentPaymentTypeOnline) {
        [amountKeyArray removeObject:ZFLocalizedString(@"OrderInfoViewModel_COD_cost",nil)];
        [amountDict removeObjectForKey:ZFLocalizedString(@"OrderInfoViewModel_COD_cost",nil)];
        
        [amountKeyArray removeObject:self.codDiscountTitle];
        [amountDict removeObjectForKey:self.codDiscountTitle];
        
        [amountKeyArray removeObject:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil)];
        [amountDict removeObjectForKey:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil)];
    }

    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:amountDict.count];
    
    for (int i = 0; i < amountDict.count; i++) {
        ZFOrderAmountDetailModel *model = [[ZFOrderAmountDetailModel alloc] init];
        model.name = amountKeyArray[i];
        model.value = [amountDict ds_stringForKey:model.name];
        [modelArray addObject:model];
    }
    return modelArray;
}

- (NSString *)queryAmountNumber {
    CGFloat num =   [self.goods_price floatValue]    +
    [self.shippingPrice floatValue]                  +
    [self.codFreight floatValue]                     +
    [self.insurance floatValue]                      -
    [self.couponAmount floatValue]                   -
    [self.pointSavePrice floatValue]                 -
    [self.activities_amount floatValue];
    return [NSString stringWithFormat:@"%lf",num];
}

- (NSString *)querySubtotal {
    CGFloat total = [self.goods_price floatValue];
    NSString *totalStr = [NSString stringWithFormat:@"%f",total];
    return [FilterManager adapterCodWithAmount:totalStr andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
}

- (NSString *)queryShippingCost {
    return [FilterManager adapterCodWithAmount:self.shippingPrice andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
}

- (NSString *)queryShippingInsurance {
    return [FilterManager adapterCodWithAmount:self.insurance andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
}

- (NSString *)queryCodCost {
    return [FilterManager adapterCodWithAmount:self.codFreight andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
}

- (NSString *)querySalesEvents {
    NSString *result = [FilterManager adapterCodWithAmount:self.activities_amount andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
    return [NSString stringWithFormat:@"- %@",result];
}

- (NSString *)queryCouponSaving {
    NSString *result = [FilterManager adapterCodWithAmount:self.couponAmount andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
    return [NSString stringWithFormat:@"- %@",result];
}

- (NSString *)queryZPointsSaving {
    NSString *result = [FilterManager adapterCodWithAmount:self.pointSavePrice andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
    return [NSString stringWithFormat:@"- %@",result];
}

- (NSString *)queryGrandTotal {
    return [FilterManager adapterCodWithAmount:[self queryAmountNumber] andCod:self.currentPaymentType == CurrentPaymentTypeCOD];
}

- (NSString *)queryCodDiscount {
    NSString *result;
    NSInteger index = [FilterManager cashOnDeliveryTruncType:self.countryID];
    switch (index) {
        case CashOnDeliveryTruncTypeUp:
        {
            self.codDiscountTitle = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_AirCargoInsurance",nil);
            result = [NSString stringWithFormat:@"+%@",[ExchangeManager transforCeilDifferencePrice:[self queryAmountNumber] currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDown:
        {
            self.codDiscountTitle = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Discount",nil);
            result = [NSString stringWithFormat:@"-%@",[ExchangeManager transforFloorDifferencePrice:[self queryAmountNumber] currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDefault:
        {
            self.codDiscountTitle = ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Discount",nil);
            result = @"";
        }
            break;
    }
    
    return result;
}

- (NSString *)queryTotalPayable {
    NSString *result;
    NSInteger index = [FilterManager cashOnDeliveryTruncType:self.countryID];
    switch (index) {
        case CashOnDeliveryTruncTypeUp:
        {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforCeilPrice:[self queryAmountNumber]  currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDown:
        {
            result = [NSString stringWithFormat:@"%@",[ExchangeManager transforFloorPrice:[self queryAmountNumber] currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDefault:
        {
            result = @"";
        }
            break;
    }
    
    return result;
}

- (NSString *)queryCashOnDelivery {
    CGFloat num = [[self queryAmountNumber] floatValue];
    NSString *title;
    switch ([FilterManager cashOnDeliveryTruncType:self.countryID]) {
        case CashOnDeliveryTruncTypeUp:
        {
            title = [NSString stringWithFormat:@"%@",[ExchangeManager transforCeilPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDefault:
        {
            title = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
        }
            break;
        case CashOnDeliveryTruncTypeDown:
        {
            title = [NSString stringWithFormat:@"%@",[ExchangeManager transforFloorPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
        }
            break;
        default:
            break;
    }
    return title;
}

- (void)queryCurrentOrderCurrency {
    NSString *str;
    if ( ([FilterManager isSupportCOD:self.countryID] && [self.paymentCode isEqualToString:@"Cod"])) {
        if ([NSStringUtils isEmptyString:[FilterManager isSupportCOD:self.countryID]]) {
            str = [ExchangeManager localCurrencyName];
        }else{
            str = [FilterManager isSupportCOD:self.countryID];
            NSArray<RateModel *> *array = [ExchangeManager currencyList];
            for (RateModel *model in array) {
                if ([model.symbol isEqualToString:str]) {
                    str = model.code;
                }
            }
        }
    } else {
        str = [ExchangeManager localCurrencyName];
    }
    self.bizhong = str;
}

- (BOOL)isShowCODGoodsAmountLimit:(NSString *)payCode checkoutModel:(ZFOrderCheckInfoDetailModel *)checkoutModel {
    if ([payCode isEqualToString:@"Cod"] &&
        ([self.goods_price floatValue] < [checkoutModel.cod.totalMin floatValue]
         || [self.goods_price floatValue] > [checkoutModel.cod.totalMax floatValue]))
    {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)appendGoodsSN:(ZFOrderCheckInfoDetailModel *)model {
    NSMutableString *goodsStr = [NSMutableString string];
    for (int i = 0; i < model.cart_goods.goods_list.count; i++) {
        CheckOutGoodListModel *goodsModel = model.cart_goods.goods_list[i];
        [goodsStr appendString:goodsModel.goods_sn];
        if (model.cart_goods.goods_list.count != 1 && i != model.cart_goods.goods_list.count - 1) {
            [goodsStr appendString:@","];
        }
    }
    return [goodsStr copy];
}

- (void)analyticsClickButton:(NSString *)payMethod state:(NSInteger)state {
    dispatch_async(dispatch_queue_create([[[NSDate date] description] UTF8String], NULL), ^{
        //增加支付方式统计
        if (![NSStringUtils isEmptyString:payMethod]) {
            if(state == FastPaypalOrderTypeSuccess ||  state == FastPaypalOrderTypeFail) {
                [ZFAnalytics clickButtonWithCategory:@"Payment Method" actionName:@"FastPayment" label:@"FastPayment"];
            } else {
                [ZFAnalytics clickButtonWithCategory:@"Payment Method" actionName:payMethod label:payMethod];
            }
        }
    });
}


@end
