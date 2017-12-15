//
//  MessageCountApi.h
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface MessageCountApi : SYBaseRequest
- (instancetype)initWithUserid:(NSString *)userid;
@end
