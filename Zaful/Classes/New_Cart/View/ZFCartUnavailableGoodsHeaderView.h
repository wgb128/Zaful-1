//
//  ZFCartUnavailableGoodsHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CartUnavailableGoodsClearAllCompletionHandler)(void);

@interface ZFCartUnavailableGoodsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) CartUnavailableGoodsClearAllCompletionHandler       cartUnavailableGoodsClearAllCompletionHandler;

@end

