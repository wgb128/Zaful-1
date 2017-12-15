//
//  ZFCartDiscountGoodsTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFCartGoodsModel;

typedef void(^CartDiscountGoodsSelectCompletionHandler)(BOOL isSelect);
typedef void(^CartDiscountGoodsCollectionCompletionHandler)(BOOL isCollection);
typedef void(^CartDiscountGoodsChangeCountCompletionHandler)(ZFCartGoodsModel *model);

@interface ZFCartDiscountGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFCartGoodsModel          *model;

@property (nonatomic, copy) CartDiscountGoodsSelectCompletionHandler        cartDiscountGoodsSelectCompletionHandler;

@property (nonatomic, copy) CartDiscountGoodsCollectionCompletionHandler    cartDiscountGoodsCollectionCompletionHandler;

@property (nonatomic, copy) CartDiscountGoodsChangeCountCompletionHandler   cartDiscountGoodsChangeCountCompletionHandler;
@end
