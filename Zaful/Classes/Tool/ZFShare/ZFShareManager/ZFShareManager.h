//
//  ZFShareManager.h
//  Zaful
//
//  Created by TsangFa on 8/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NativeShareModel;

@interface ZFShareManager : NSObject

+ (instancetype)shareManager;

/**
 * 分享数据模型
 */
@property (nonatomic, strong) NativeShareModel   *model;

/**
 * FaceBook 分享
 */
- (void)shareToFacebook;

/**
 * Messenger 分享
 */
- (void)shareToMessenger;

/**
 * copy link
 */
- (void)copyLinkURL;


@end
