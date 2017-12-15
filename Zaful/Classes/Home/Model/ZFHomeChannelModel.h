//
//  ZFHomeChannelModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "BannerModel.h"

@interface ZFHomeChannelModel : NSObject

@property (nonatomic, strong) NSArray <BannerModel *> *bannerArray;
@property (nonatomic, strong) NSArray <GoodsModel *>  *goodsArray;

- (void)requestHomeChannelWithParam:(id)paramaters completeHandler:(void (^)(NSString *message, BOOL isSuccess))completeHandler;
- (NSInteger)totalPages;
- (NSInteger)currentPage;

@end
