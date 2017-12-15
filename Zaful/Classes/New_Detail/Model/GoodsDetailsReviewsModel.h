//
//  GoodsDetailsReviewsModel.h
//  Yoshop
//
//  Created by huangxieyue on 16/6/10.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsDetailsReviewsSummaryModel;

@interface GoodsDetailsReviewsModel : NSObject

@property (nonatomic,strong) NSArray *reviewList;//评论列表
@property (nonatomic,assign) float agvRate;//评论总分
@property (nonatomic,assign) NSInteger reviewCount;//评论条数
@property (nonatomic,assign) NSInteger pageCount;//总页数
@property (nonatomic,assign) NSInteger page;//页数

@end

