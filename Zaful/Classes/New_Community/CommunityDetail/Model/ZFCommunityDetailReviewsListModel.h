//
//  ZFCommunityDetailReviewsListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityDetailReviewsListModel : NSObject

@property (nonatomic,strong) NSArray *list;//评论列表
@property (nonatomic,assign) NSInteger curPage;//当前页数
@property (nonatomic,assign) NSInteger pageCount;//总页数
@property (nonatomic,copy) NSString *type;//类型

@end
