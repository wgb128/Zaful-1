//
//  ZFOrderCheckDoneModel.h
//  Zaful
//
//  Created by TsangFa on 24/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFOrderCheckDoneDetailModel;
@interface ZFOrderCheckDoneModel : NSObject
@property (nonatomic, strong) ZFOrderCheckDoneDetailModel         *order_info;
@property (nonatomic, assign) NSInteger                           node;                       // 1 cod方式， 2 online方式 3.组合方式
@property (nonatomic, assign) BOOL                                isSuccess;                  // 是否支付成功

@end
