//
//  PaymentListModel.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/6.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentListModel : NSObject

@property (nonatomic, copy) NSString *pay_code;

@property (nonatomic, copy) NSString *pay_id;

@property (nonatomic, copy) NSString *pay_name;

@property (nonatomic, copy) NSString *pay_shuoming;

@property (nonatomic, copy) NSString *used_currencies;

@property (nonatomic, copy) NSString *default_select;

@end
