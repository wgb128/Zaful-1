//
//  ZFCartListResultModel.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCartGoodsListModel;

@interface ZFCartListResultModel : NSObject <YYModel>
@property (nonatomic, strong) NSString              *totalAmount;
@property (nonatomic, strong) NSString              *discountAmount;
@property (nonatomic, assign) NSInteger             totalNumber;
@property (nonatomic, strong) NSArray<ZFCartGoodsListModel *> *goodsBlockList;
@end
