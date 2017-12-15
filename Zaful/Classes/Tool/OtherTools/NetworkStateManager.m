//
//  YSNetworkStateManager.m
//  Yoshop
//
//  Created by zhaowei on 16/6/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "NetworkStateManager.h"

@implementation NetworkStateManager
+ (void)networkState:(void (^)())executeBlock exception:(void (^)())exceptionBlock {
    
    if (executeBlock) {
        executeBlock();
    }
}
@end
