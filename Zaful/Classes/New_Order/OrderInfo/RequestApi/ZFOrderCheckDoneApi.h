//
//  ZFOrderCheckDoneApi.h
//  Zaful
//
//  Created by TsangFa on 24/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFOrderCheckDoneApi : SYBaseRequest


- (instancetype)initWithPayCoder:(NSString *)payCode parametersArray:(NSArray *)parametersArray;

@end
