//
//  ZFGoodsDetailLinkInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFGoodsDetailLinkInfoType) {
    ZFGoodsDetailLinkInfoTypeShippingTips = 0,
    ZFGoodsDetailLinkInfoTypeProductDescription,
    ZFGoodsDetailLinkInfoTypeSizeGuide,
    ZFGoodsDetailLinkInfoTypeModelStats,
};

typedef void(^GoodsDetailLinkJumpCompletionHandler)(NSString *url, NSString *title);

@interface ZFGoodsDetailLinkInfoView : UITableViewHeaderFooterView
@property (nonatomic, assign) ZFGoodsDetailLinkInfoType             linkType;
@property (nonatomic, copy) NSString                                *linkUrl;
@property (nonatomic, copy) GoodsDetailLinkJumpCompletionHandler    goodsDetailLinkJumpCompletionHandler;
@end
