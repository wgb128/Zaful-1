//
//  ZFPaymentStatusOptionView.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFPaymentStatusOptionType) {
    ZFPaymentStatusOptionTypeCombinedWaitForPayment = 0,
    ZFPaymentStatusOptionTypeOnlineSuccess,
    ZFPaymentStatusOptionTypeCodSuccess,
    ZFPaymentStatusOptionTypeCombinedSuccess,
    ZFPaymentStatusOptionTypeOnlineFail,
    ZFPaymentStatusOptionTypeCodFail,
};

@interface ZFPaymentStatusOptionView : UITableViewHeaderFooterView

@property (nonatomic, assign) ZFPaymentStatusOptionType         statusType;

@end
