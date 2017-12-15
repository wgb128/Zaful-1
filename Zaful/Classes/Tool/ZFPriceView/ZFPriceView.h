//
//  ZFPriceView.h
//  Zaful
//
//  Created by TsangFa on 14/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFBaseGoodsModel;

@interface ZFPriceView : UIView

@property (nonatomic, strong) ZFBaseGoodsModel   *model;

- (void)clearAllData;

@end
