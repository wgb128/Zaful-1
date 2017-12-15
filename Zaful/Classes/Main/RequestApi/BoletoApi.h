//
//  BoletoApi.h
//  Zaful
//
//  Created by TsangFa on 4/11/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface BoletoApi : SYBaseRequest

-(instancetype)initWithOrderID:(NSString *)orderid;

@end
