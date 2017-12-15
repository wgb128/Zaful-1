//
//  CommunityDetailReviewsModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityDetailReviewsModel : NSObject

@property (nonatomic,strong) NSArray *list;//评论列表
@property (nonatomic,assign) NSInteger curPage;//当前页数
@property (nonatomic,assign) NSInteger pageCount;//总页数
@property (nonatomic,copy) NSString *type;//类型

@end
