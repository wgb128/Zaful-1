//
//  RegisterApi.h
//  Zaful
//
//  Created by ZJ1620 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface RegisterApi : SYBaseRequest

-(instancetype)initWithEmail:(NSString *)email
                    password:(NSString *)password
             confirmPassword:(NSString *)confirmPassword
                         sex:(NSString *)sex
                 issubscribe:(NSString *)issubscribe;

@end
