//
//  AccountModel.h
//  Yoshop
//
//  Created by zhaowei on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject <NSCoding,NSCopying,NSMutableCopying>

@property(nonatomic, copy)      NSString *email;  ///邮箱

@property(nonatomic, assign)    UserEnumSexType sex;//性别{0未知1男2女}

@property(nonatomic, copy)      NSString *firstname;//名

@property (nonatomic, copy)     NSString *lastname;//姓

@property(nonatomic, copy)      NSString *nickname;//昵称

@property(nonatomic, copy)      NSString *addressId;// 用户地址ID

@property(nonatomic, copy)      NSString *phone;//电话

@property (nonatomic, copy)     NSString *birthday;// 生日

@property(nonatomic, copy)      NSString *avatar;//头像

@property (nonatomic, copy)     NSString *password;//密码

@property (nonatomic, copy)     NSString *token;// api token

@property (nonatomic, copy)     NSString *sess_id;

@property (nonatomic, copy)     NSString *user_id;//用户编号

@property (nonatomic, copy)     NSString *order_number;// 订单数量

@property (nonatomic, copy)     NSString *collect_number;// 收藏夹数量

@end
