//
//  NativeShareModel.h
//  Zaful
//
//  Created by TsangFa on 31/7/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NativeShareModel : NSObject
/**
 * 分享标题
 */
@property (nonatomic, copy) NSString   *share_title;
/**
 * 分享描述
 */
@property (nonatomic, copy) NSString   *share_description;

/**
 * 分享图片链接(其他平台)
 * 这个属性主要用于测试环境,fb构建分享的时候,此字段已失效,但不传会分享失败
 */
@property (nonatomic, copy) NSString   *share_imageURL;
/**
 * 分享链接
 */
@property (nonatomic, copy) NSString   *share_url;


@end
