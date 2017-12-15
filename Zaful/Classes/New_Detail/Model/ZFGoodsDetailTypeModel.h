//
//  ZFGoodsDetailTypeModel.h
//  Zaful
//
//  Created by liuxi on 2017/11/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZFGoodsDetailType) {
    ZFGoodsDetailTypeGoodsInfo = 0,
    ZFGoodsDetailTypeQualified,
    ZFGoodsDetailTypeSizeInfo,
    ZFGoodsDetailTypeShippingTips,
    ZFGoodsDetailTypeDescription,
    ZFGoodsDetailTypeSizeGuide,
    ZFGoodsDetailTypeModelStats,
    ZFGoodsDetailTypeReview,
    ZFGoodsDetailTypeRecommend,
    
};

@interface ZFGoodsDetailTypeModel : NSObject
@property (nonatomic, assign) ZFGoodsDetailType         type;
@end
