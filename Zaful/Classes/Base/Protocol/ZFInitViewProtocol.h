//
//  ZFInitViewProtocol.h
//  Zaful
//
//  Created by liuxi on 2017/7/10.
//  Copyright © 2017年 Y001. All rights reserved.
//
#import <Foundation/Foundation.h>

/*!
 *  @brief 用于布局
 */
@protocol ZFInitViewProtocol <NSObject>

@required
/*!
 *  @brief 添加试图
 */
- (void)zfInitView;

/*!
 *  @brief 布局
 */
- (void)zfAutoLayoutView;

@end
