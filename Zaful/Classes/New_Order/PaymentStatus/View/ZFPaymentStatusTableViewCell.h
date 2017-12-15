//
//  ZFPaymentStatusTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFPaymentStatusType) {
    ZFPaymentStatusTypeCombinedWaitForPayment = 0,
    ZFPaymentStatusTypeOnlineSuccess,
    ZFPaymentStatusTypeCodSuccess,
    ZFPaymentStatusTypeCombinedSuccess,
    ZFPaymentStatusTypeOnlineFail,
    ZFPaymentStatusTypeCodFail,
};

@interface ZFPaymentStatusTableViewCell : UITableViewCell
@property (nonatomic, assign) ZFPaymentStatusType           statusType;
@end
