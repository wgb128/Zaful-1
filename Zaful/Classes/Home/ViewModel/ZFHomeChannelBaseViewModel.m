//
//  ZFHomeChannelBaseViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelBaseViewModel.h"

@interface ZFHomeChannelBaseViewModel ()

@end

@implementation ZFHomeChannelBaseViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.rowCount     = 0;
        self.footerSize   = CGSizeMake(0.0, 0.0);
        self.headerSize   = CGSizeMake(0.0, 0.0);
        self.headerTitle  = @"";
        self.edgeInsets   = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumLineSpacing      = 5.0f;
        self.minimumInteritemSpacing = 0.0f;
        self.rowSize                 = CGSizeMake(KScreenWidth, 0.0f);
    }
    return self;
}

#pragma mark getter/setter
- (void)setRowCount:(NSInteger)rowCount {
    _rowCount = rowCount;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
}

@end
