//
//  GoodsDetailFirstReviewModel.h
//  Zaful
//
//  Created by TsangFa on 17/1/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailFirstReviewModel : NSObject

@property (nonatomic,copy)   NSString *userName;//用户名称
@property (nonatomic,copy)   NSString *content;//评论内容
@property (nonatomic,copy)   NSString *time;//评论时间
@property (nonatomic,copy)   NSString *star;//评价分数
@property (nonatomic,copy)   NSString *avatar;//用户头像
@property (nonatomic,strong) NSArray *imgList;//上传的图片

@end
