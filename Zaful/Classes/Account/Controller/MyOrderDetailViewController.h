//
//  MyOrderDetailViewController.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
typedef void (^ReloadOrderListBlock) (MyOrderDetailOrderModel *statusModel);

@interface MyOrderDetailViewController : ZFBaseViewController
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy) ReloadOrderListBlock reloadOrderListBlock;
@end
