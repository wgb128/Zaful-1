//
//  ZFHomeChannelNewGoodsViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelBaseViewModel.h"

#import "GoodsModel.h"

@interface ZFHomeChannelNewGoodsViewModel : ZFHomeChannelBaseViewModel

@property (nonatomic, strong) NSArray <GoodsModel *> *goodsArray;

@end
