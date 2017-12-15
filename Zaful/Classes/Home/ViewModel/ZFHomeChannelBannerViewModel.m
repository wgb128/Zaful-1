//
//  ZFHomeChannelBannerViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelBannerViewModel.h"

@implementation ZFHomeChannelBannerViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.type       = ZFHomeChannelBanner;
        self.headerSize = CGSizeMake(SCREEN_WIDTH, 0.0f);
        self.minimumLineSpacing = 5.0f;
    }
    return self;
}

- (void)setBanners:(NSArray<BannerModel *> *)banners {
    _banners = banners;
    [self setRowCount:banners.count];
}

- (CGSize)rowSizeAtRowIndex:(NSInteger)index {
    BannerModel *model   = self.banners[index];
    CGFloat bannerHeight = [model.banner_height floatValue] * 0.5;
    return CGSizeMake(SCREEN_WIDTH, bannerHeight * DSCREEN_WIDTH_SCALE);
}

@end
