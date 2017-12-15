//
//  JumpModel.h
//  Zaful
//
//  Created by DBP on 16/10/25.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JumpModel : NSObject <NSCoding>

#define DeepLinkModel @"ZafulDeepLinkModel"
@property (nonatomic, assign) JumpActionType actionType; // 跳转类型
@property (nonatomic, copy) NSString *url;  // 很多东西。(HTML5页面URL 或 频道id) goodsId + wid,（不只是一个简单类型）
@property (nonatomic, copy) NSString *name; // 跳转后的标题 导购词

@property (nonatomic, copy) NSString *startTime; // 活动开始时间
@property (nonatomic, copy) NSString *endTime; // 活动结束时间
@property (nonatomic, copy) NSString *bannerId; //  (banner主键)


@property (nonatomic, assign) BOOL isShare; // 是否分享  == (是否分享 0否 1是)
@property (nonatomic, copy) NSString *shareTitle; // 分享标题
@property (nonatomic, copy) NSString *imageURL; // 图片的路径 展示
@property (nonatomic, copy) NSString *shareImageURL; // 分享小图片链接
@property (nonatomic, copy) NSString *shareLinkURL; // 分享地址
@property (nonatomic, copy) NSString *shareDoc; // 分享文案

@property (nonatomic, copy) NSString *leftTime; // 剩余时间
@property (nonatomic, copy) NSString *serverTime; // 服务器时间，我们要做倒计时

@end
