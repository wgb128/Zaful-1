//
//  ZFOrderCheckInfoApi.h
//  Zaful
//
//  Created by TsangFa on 2017/10/13.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFOrderCheckInfoApi : SYBaseRequest

- (instancetype)initWithPayCoder:(NSString *)payCode parametersArray:(NSArray *)parametersArray;

@end
