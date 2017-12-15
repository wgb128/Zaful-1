//
//  CartGoodsModel.h
//  Zaful
//
//  Created by 7FD75 on 16/9/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartGoodsModel : NSObject

@property (nonatomic, strong) NSArray *goods_list;

@property (nonatomic, copy) NSString *is_use_pcode_success;

@property (nonatomic, copy) NSString *pcode_msg;

@end
