//
//  ZFHomeChannelViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelViewModel.h"

@interface ZFHomeChannelViewModel ()

@property (nonatomic, strong) ZFHomeChannelModel *homeChannelModel;

@end

@implementation ZFHomeChannelViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.channelItems     = [NSMutableArray new];
        self.homeChannelModel = [[ZFHomeChannelModel alloc] init];
    }
    return self;
}

- (void)requestHomeChannelWithParam:(id)parmaters completeHandler:(void (^)(void))completeHandler {
    
    [self.homeChannelModel requestHomeChannelWithParam:parmaters completeHandler:^(NSString *message, BOOL isSuccess) {
        
        [self.channelItems removeAllObjects];
        if (self.homeChannelModel.bannerArray.count > 0) {
            ZFHomeChannelBannerViewModel *bannerViewModel = [[ZFHomeChannelBannerViewModel alloc] init];
            bannerViewModel.banners = self.homeChannelModel.bannerArray;
            if (bannerViewModel.banners.count > 0) {
                [self.channelItems addObject:bannerViewModel];
            }
        }
        
        if (self.homeChannelModel.goodsArray.count > 0) {
            ZFHomeChannelNewGoodsViewModel *goodsViewModel = [[ZFHomeChannelNewGoodsViewModel alloc] init];
            goodsViewModel.goodsArray = self.homeChannelModel.goodsArray;
            
            if (self.channelItems.count <= 0) {
                goodsViewModel.headerSize = CGSizeMake(SCREEN_WIDTH, 0.0f);
            }
            
            if (goodsViewModel.goodsArray.count > 0) {
                [self.channelItems addObject:goodsViewModel];
            }
        }
        
        self.message   = message;
        self.isSuccess = isSuccess;
        completeHandler();
    }];
}

- (CGSize)rowSizeAtIndexPath:(NSIndexPath *)indexPath {
    ZFHomeChannelBaseViewModel *rowViewModel = self.channelItems[indexPath.section];
    if ([rowViewModel isKindOfClass:ZFHomeChannelBannerViewModel.class]) {
        ZFHomeChannelBannerViewModel *bannerViewModel = (ZFHomeChannelBannerViewModel *)rowViewModel;
        return [bannerViewModel rowSizeAtRowIndex:indexPath.row];
    } else {
        return rowViewModel.rowSize;
    }
}

#pragma mark - getter/setter
- (NSInteger)currentPage {
    return [self.homeChannelModel currentPage];
}

- (NSInteger)totalPage {
    return [self.homeChannelModel totalPages];
}

@end
