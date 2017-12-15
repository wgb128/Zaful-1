//
//  VideoDetailModel.h
//  Zaful
//
//  Created by huangxieyue on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

/*
 **************************************
 *
 *
 *  视频详情 -> 视频数据model
 *
 *
 ***************************************
 */

#import <Foundation/Foundation.h>

@class VideoDetailInfoModel;

@interface VideoDetailModel : NSObject

@property (nonatomic, strong) VideoDetailInfoModel *videoInfo;

@property (nonatomic, strong) NSArray *goodsList;

@end
