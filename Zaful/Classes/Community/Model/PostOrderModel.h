//
//  PostOrderModel.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostOrderListModel.h"

@interface PostOrderModel : NSObject
@property (nonatomic, strong) NSString   *  total;          //页数
@property (nonatomic, strong) NSString   *  total_page;    //收藏商品统计
@property (nonatomic, strong) NSArray    *  data;          //列表数据
@property (nonatomic, strong) NSString   *  page;          //当前页
@property (nonatomic, strong) NSString   *  page_size;     //每页个数

@end
