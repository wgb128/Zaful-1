//
//  ZFGoodsDetailSepareEmptyView.m
//  Zaful
//
//  Created by liuxi on 2017/11/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailSepareEmptyView.h"

@implementation ZFGoodsDetailSepareEmptyView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return self;
}

@end
