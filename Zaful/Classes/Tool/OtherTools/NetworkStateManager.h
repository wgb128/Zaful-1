//
//  YSNetworkStateManager.h
//  Yoshop
//
//  Created by zhaowei on 16/6/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkStateManager : NSObject
+ (void)networkState:(void (^)())executeBlock exception:(void (^)())exceptionBlock;
@end
