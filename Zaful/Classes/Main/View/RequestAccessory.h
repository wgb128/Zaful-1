//
//  YSRequestAccessory.h
//  Yoshop
//
//  Created by zhaowei on 16/5/28.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAccessory : NSObject<SYBaseRequestAccessory>

+ (instancetype)showLoadingView:(UIView *)view;

@end
