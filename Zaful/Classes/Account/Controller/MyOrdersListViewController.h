//
//  MyOrdersListViewController.h
//  Yoshop
//
//  Created by Qiu on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface MyOrdersListViewController : ZFBaseViewController


/**
 *  生成订单支付完成后,跳转到个人中心时需要请求Cart number，来刷新购物图标的badge数量
 */

@property (nonatomic, assign) BOOL isFromCreateOrderJump;

@end
