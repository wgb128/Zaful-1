//
//  YSRequestAccessory.m
//  Yoshop
//
//  Created by zhaowei on 16/5/28.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "RequestAccessory.h"

@interface RequestAccessory ()
@property (nonatomic, strong) UIView   *view;
@end

@implementation RequestAccessory

+ (instancetype)showLoadingView:(UIView *)view {
    RequestAccessory *accessory = [[RequestAccessory alloc] init];
    accessory.view = view;
    return accessory;
}


- (void)requestStart:(id)request {
    [MBProgressHUD showLoadingView:self.view];
}

- (void)requestStop:(id)request {
    [MBProgressHUD hideHUD];
}
@end
