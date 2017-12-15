//
//  ZFHomeChannelViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZFHomeChannelModel.h"

#import "ZFHomeChannelBaseViewModel.h"
#import "ZFHomeChannelBannerViewModel.h"
#import "ZFHomeChannelNewGoodsViewModel.h"

@interface ZFHomeChannelViewModel : NSObject


@property (nonatomic, strong) NSMutableArray <ZFHomeChannelBaseViewModel *> *channelItems;
@property (nonatomic, copy  ) NSString            *message;
@property (nonatomic, assign) BOOL                isSuccess;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) NSInteger totalPage;

- (void)requestHomeChannelWithParam:(id)parmaters completeHandler:(void (^)(void))completeHandler;
- (CGSize)rowSizeAtIndexPath:(NSIndexPath *)indexPath;

@end
