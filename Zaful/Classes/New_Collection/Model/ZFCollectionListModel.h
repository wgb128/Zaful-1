//
//  ZFCollectionListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCollectionModel;

@interface ZFCollectionListModel : NSObject
@property (nonatomic, copy) NSString   *total;          //页数
@property (nonatomic, copy) NSString   *total_page;    //收藏商品统计
@property (nonatomic, copy) NSString   *page;          //当前页
@property (nonatomic, copy) NSString   *page_size;     //每页个数
@property (nonatomic, strong) NSMutableArray<ZFCollectionModel *>  *data;          //列表数据
@end
