//
//  OrderDetailViewController.h
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
typedef void (^ReloadOrderListBlock) (OrderDetailOrderModel *statusModel);

@interface OrderDetailViewController : ZFBaseViewController
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy) ReloadOrderListBlock reloadOrderListBlock;
@end
