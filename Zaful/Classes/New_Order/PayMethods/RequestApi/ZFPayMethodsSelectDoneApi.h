//
//  ZFPayMethodsSelectDoneApi.h
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFPayMethodsSelectDoneApi : SYBaseRequest

- (instancetype)initWithPayCoder:(NSString *)payCode parametersArray:(NSArray *)parametersArray;

@end
