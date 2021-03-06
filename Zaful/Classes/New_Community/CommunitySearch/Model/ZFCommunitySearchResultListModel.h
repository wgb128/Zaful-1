//
//  ZFCommunitySearchResultListModel.h
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCommunitySearchResultModel;
@interface ZFCommunitySearchResultListModel : NSObject
@property (nonatomic, strong) NSArray<ZFCommunitySearchResultModel *> *searchList;//评论列表
@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSString *curPage;//当前页数
@end
