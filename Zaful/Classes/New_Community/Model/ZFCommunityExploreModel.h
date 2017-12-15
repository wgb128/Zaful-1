//
//  ZFCommunityExploreModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCommunityFavesItemModel;
@interface ZFCommunityExploreModel : NSObject
@property (nonatomic, strong) NSArray<ZFCommunityFavesItemModel *> *list;//评论列表
@property (nonatomic, strong) NSArray *bannerlist;//banner数组
@property (nonatomic, strong) NSArray *video;//视频
@property (nonatomic, strong) NSArray *topicList;//话题
@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSString *curPage;//当前页数
@property (nonatomic, copy) NSString *type;//类型
@end
