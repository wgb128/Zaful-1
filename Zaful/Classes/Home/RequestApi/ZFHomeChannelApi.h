//
//  ZFHomeChannelApi.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFHomeChannelApi : SYBaseRequest

- (instancetype)initWithChannelId:(NSString *)channelId pageNO:(NSString *)pageNO pageSize:(NSString *)pageSize;

@end
