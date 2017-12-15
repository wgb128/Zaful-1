//
//  ZFHomeChannelBaseViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZFHomeChannelDataType) {
    ZFHomeChannelAdvertising = 0,  // 广告轮播图
    ZFHomeChannelCategory,         // 分类
    ZFHomeChannelBanner,           // Banner
    ZFHomeChannelNewGoods          // 新品
};
@interface ZFHomeChannelBaseViewModel : NSObject

@property (nonatomic, assign) ZFHomeChannelDataType type;

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, assign, readonly) NSInteger rowCount;
@property (nonatomic, assign) CGSize rowSize;

- (void)setRowCount:(NSInteger)rowCount;

@end
