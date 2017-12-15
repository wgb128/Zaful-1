//
//  UIView+ZFEmptyView.h
//  WZHLibrary
//
//  Created by QianHan on 2017/5/12.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString const *ZFBlankViewBackgroudViewKey;
/**
 视图空白页
 */
@interface UIView (ZFBlankView)

/**
 显示数据提示

 @param image 提示的图标
 @param description 提示内容
 @param titles 操作按钮标题集
 @param action 操作事件
 */
- (void)zf_showBlankViewWithImage:(UIImage *)image
                       description:(NSString *)description
                      buttonTitles:(NSArray *)titles
                            action:(void (^)(NSInteger index))action;

/**
 隐藏空数据提示
 */
- (void)zf_dismissBlankView;

/**
 由于网络原因造成的空白页

 @param action 空白页操作
 */
- (void)zf_showNetworkBlankViewWithAction:(void (^)(NSInteger index))action;

/**
 由于请求返回code != 0原因造成的空白页
 
 @param action 空白页操作
 */
- (void)zf_showRequestBlankViewWithAction:(void (^)(NSInteger index))action;

@end
