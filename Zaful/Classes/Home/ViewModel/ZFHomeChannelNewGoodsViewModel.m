//
//  ZFHomeChannelNewGoodsViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelNewGoodsViewModel.h"

@implementation ZFHomeChannelNewGoodsViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.type       = ZFHomeChannelNewGoods;
        self.edgeInsets = UIEdgeInsetsMake(0, 16.0f, 0, 16.0f);
        self.headerSize = CGSizeMake(SCREEN_WIDTH, 12.0f);
        self.minimumLineSpacing = 16.0f;
        self.minimumInteritemSpacing = 16.0f;
        self.rowSize    = CGSizeMake((SCREEN_WIDTH - 48) / 2, 218 * DSCREEN_WIDTH_SCALE + 58);
        self.headerTitle = @"";
    }
    return self;
}

- (void)setGoodsArray:(NSArray<GoodsModel *> *)goodsArray {
    _goodsArray = goodsArray;
    [self setRowCount:goodsArray.count];
}

@end
