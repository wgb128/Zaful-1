//
//  ZFHomeChannelAdViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelAdViewModel.h"

@implementation ZFHomeChannelAdViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.type    = ZFHomeChannelAdvertising;
        self.rowSize = CGSizeMake(SCREEN_WIDTH, 300.0 * DSCREEN_WIDTH_SCALE);
        [self setRowCount:1];
    }
    return self;
}

@end
