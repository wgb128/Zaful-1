//
//  SystemConfigUtils.h
//  Zaful
//
//  Created by zhaowei on 2017/2/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigUtils : NSObject
//当前语言是阿拉伯语
+ (BOOL)isRightToLeftLanguage;
//判断当前是否支持View反向
+ (BOOL)isCanRightToLeftShow;
//当前View是反向显示
+ (BOOL)isRightToLeftShow;
@end
