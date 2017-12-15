//
//  ZFCartGoodsListModel.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCartGoodsModel;

@interface ZFCartGoodsListModel : NSObject
@property (nonatomic, copy) NSString                        *url;
@property (nonatomic, copy) NSString                        *msg;
@property (nonatomic, copy) NSString                        *goodsModuleType;
@property (nonatomic, strong) NSArray<ZFCartGoodsModel *>   *cartList;
@end
