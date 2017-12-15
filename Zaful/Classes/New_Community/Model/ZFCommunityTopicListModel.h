//
//  ZFCommunityTopicListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityTopicListModel : NSObject
@property (nonatomic, strong) NSArray *list;//列表
@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSString *curPage;//当前页数
@property (nonatomic, copy) NSString *type;//类型
@end
