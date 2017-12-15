//
//  SearchGoodsModel.h
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SearchGoodsModel.h"

@interface SearchResultModel : NSObject<YYModel>

@property (nonatomic, strong) NSMutableArray * goodsArray;
@property (nonatomic, assign) NSInteger result_num;
@property (nonatomic, assign) NSInteger total_page;
@property (nonatomic, assign) NSInteger cur_page;

@end
