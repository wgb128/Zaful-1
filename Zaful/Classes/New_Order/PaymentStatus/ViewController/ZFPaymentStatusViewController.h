//
//  ZFPaymentStatusViewController.h
//  Zaful
//
//  Created by TsangFa on 2017/10/12.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import "ZFBaseViewController.h"

@class ZFOrderCheckDoneModel;
@class ZFOrderManager;

typedef void(^PayStatesBlock)();

@interface ZFPaymentStatusViewController : ZFBaseViewController

@property (nonatomic, strong) NSArray<ZFOrderCheckDoneModel *>        *dataArray;

@property (nonatomic, strong) NSArray<ZFOrderManager *>               *managerArray;

@property (nonatomic, copy) PayStatesBlock                            payStatesBlock;

@end

