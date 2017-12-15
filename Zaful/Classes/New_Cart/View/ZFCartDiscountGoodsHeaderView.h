//
//  ZFCartDiscountGoodsHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCartGoodsListModel;
typedef void(^CartDiscountTopicJumpCompletionHandler)(void);

@interface ZFCartDiscountGoodsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) ZFCartGoodsListModel      *model;

@property (nonatomic, copy) CartDiscountTopicJumpCompletionHandler      cartDiscountTopicJumpCompletionHandler;
@end
