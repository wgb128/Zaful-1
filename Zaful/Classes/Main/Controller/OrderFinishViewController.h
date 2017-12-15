//
//  YSOrderFinishViewController.h
//  Yoshop
//
//  Created by 7F-shigm on 16/6/24.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZFBaseViewController.h"

typedef void(^OrderFinishBlock)(BOOL isAccount);

@interface OrderFinishViewController : ZFBaseViewController

@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *paymentAccount;

@property (nonatomic, copy) OrderFinishBlock toAccountOrHomeblock;

@property (nonatomic, assign) BOOL isVerifcation;// 判断是不是货到付款

@end
