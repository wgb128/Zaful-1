//
//  PopularModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopularModel : NSObject

@property (nonatomic, strong) NSArray *list;//评论列表
@property (nonatomic, strong) NSArray *bannerlist;//banner数组
@property (nonatomic, strong) NSArray *video;//视频
@property (nonatomic, strong) NSArray *topicList;//话题
@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSString *curPage;//当前页数
@property (nonatomic, copy) NSString *type;//类型

@end
