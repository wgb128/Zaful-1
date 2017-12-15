//
//  ZFHomeChannelBannerViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelBaseViewModel.h"
#import "BannerModel.h"

@interface ZFHomeChannelBannerViewModel : ZFHomeChannelBaseViewModel

@property (nonatomic, strong) NSArray <BannerModel *> *banners;
- (CGSize)rowSizeAtRowIndex:(NSInteger)index;

@end
