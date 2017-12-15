//
//  SendCodeApi.h
//  Zaful
//
//  Created by TsangFa on 17/3/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface SendCodeApi : SYBaseRequest

- (instancetype)initWithAddressID:(NSString *)addressID;

@end
