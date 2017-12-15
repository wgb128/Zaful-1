//
//  FavesModel.h
//  Zaful
//
//  Created by huangxieyue on 16/11/26.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavesModel : NSObject

@property (nonatomic, strong) NSArray *list;//评论列表
@property (nonatomic, assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSString *curPage;//当前页数
@property (nonatomic, copy) NSString *type;//类型

@end
