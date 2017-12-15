//
//  ZFOrderInfoFooterView.h
//  Zaful
//
//  Created by TsangFa on 21/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFOrderInfoFooterModel;

typedef void(^OrderInfoH5Block)(NSString *url);

@interface ZFOrderInfoFooterView : UIView

@property (nonatomic, copy) OrderInfoH5Block   orderInfoH5Block;

@property (nonatomic, strong) ZFOrderInfoFooterModel   *model;

@end
