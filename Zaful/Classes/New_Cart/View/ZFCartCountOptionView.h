//
//  ZFCartCountOptionView.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartGoodsCountChangeCompletionHandler)(NSInteger number);

@interface ZFCartCountOptionView : UIView
@property (nonatomic, assign) NSInteger         goodsNumber;
@property (nonatomic, assign) NSInteger         maxGoodsNumber;

@property (nonatomic, copy) CartGoodsCountChangeCompletionHandler     cartGoodsCountChangeCompletionHandler;
@end
