//
//  PostOrderListModel.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostOrderListModel : NSObject
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_sn;
@property (nonatomic,copy) NSString *goods_thumb;
@property (nonatomic,copy) NSString *goods_title;
@property (nonatomic,copy) NSString *shop_price;
@property (nonatomic,assign) BOOL isSelected;
@end
