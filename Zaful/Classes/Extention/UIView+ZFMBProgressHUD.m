

//
//  UIView+ZFMBProgressHUD.m
//  Zaful
//
//  Created by liuxi on 2017/7/11.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "UIView+ZFMBProgressHUD.h"
#import <objc/runtime.h>

@implementation UIView (ZFMBProgressHUD)
- (void)showHUDDefaultLoadingText {
    [self showHUDText:@"Loading..."];
}

- (void)showHUDText:(NSString *)text {
    [self showHUDText:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showHUDOnlyText:(NSString *)text {
    [self showHUDText:text mode:MBProgressHUDModeText afterDealy:0];
}

- (void)showHUDText:(NSString *)text afterDealy:(NSTimeInterval)afterDealy{
    [self showHUDText:text mode:MBProgressHUDModeText afterDealy:afterDealy];
}

- (void)showHUDTextAfterDealy:(NSString *)text {
    [self showHUDText:text mode:MBProgressHUDModeText afterDealy:2.0f];
}

- (void)showHUDText:(NSString *)text mode:(MBProgressHUDMode)mode {
    [self showHUDText:text mode:mode afterDealy:0];
}

- (void)showHUDText:(NSString *)text mode:(MBProgressHUDMode)mode afterDealy:(NSTimeInterval)afterDealy {
    if (self.isLoadingHUD) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self bringSubviewToFront:hud];
    hud.mode = mode;
    hud.labelColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.detailsLabelText = text;
    objc_setAssociatedObject(self, "MBProgressHUD", hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (afterDealy > 0 && mode == MBProgressHUDModeText) {
        
        [hud hide:YES afterDelay:afterDealy];
    }
    // 测试添加一个 超时 60s 自动停止的优化
    [hud hide:YES afterDelay:60.0];
}

- (void)hideHUD {
    [self hideHUDTextAfterDealy:nil];
}

- (void)hideHUDTextAfterDealy:(NSString *)text {
    [self hideHUDText:text afterDealy:2.0f];
}

- (void)hideHUDText:(NSString *)text afterDealy:(NSTimeInterval )afterDealy {
    if (!self.isLoadingHUD) {
        return;
    }
    MBProgressHUD *hud = objc_getAssociatedObject(self, "MBProgressHUD");
    hud.removeFromSuperViewOnHide = YES;
    if (!text) {
        [hud hide:YES];
    }else {
        hud.labelText = nil;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = text;
        hud.labelFont = [UIFont systemFontOfSize:13];
        [hud hide:YES afterDelay:afterDealy];
    }
}

#pragma mark - get

- (BOOL)isLoadingHUD {
    MBProgressHUD *hud = objc_getAssociatedObject(self, "MBProgressHUD");
    return hud.superview?YES:NO;;
}
@end
