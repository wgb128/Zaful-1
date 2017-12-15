//
//  ZFHomeChannelCategoryViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelCategoryViewModel.h"

@implementation ZFHomeChannelCategoryViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.type       = ZFHomeChannelCategory;
        self.headerSize = CGSizeMake(SCREEN_WIDTH, 12);
        self.minimumLineSpacing      = 5.0f;
        self.minimumInteritemSpacing = 5.0f;
        self.rowSize    = CGSizeMake((SCREEN_WIDTH - 5) * 0.5, 190 * DSCREEN_WIDTH_SCALE);
    }
    return self;
}

- (void)setCategoryArray:(NSArray<BannerModel *> *)categoryArray {
    _categoryArray = categoryArray;
    [self setRowCount:categoryArray.count];
}

@end
