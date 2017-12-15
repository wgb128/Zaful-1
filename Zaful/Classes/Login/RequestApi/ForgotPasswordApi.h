//
//  ForgotPasswordApi.h
//  Zaful
//
//  Created by ZJ1620 on 16/9/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ForgotPasswordApi : SYBaseRequest

-(instancetype)initWithEmail:(NSString *)email;

@end
