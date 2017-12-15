//
//  ZFHomeChannelModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeChannelModel.h"
#import "ZFHomeChannelApi.h"
#import "ZFChannelBannerModel.h"
#import "ZFChannelGoodsModel.h"

@interface ZFHomeChannelModel () {
    
    NSInteger _currentPage;
    NSInteger _totalPage;
}

@end

@implementation ZFHomeChannelModel

- (instancetype)init {
    if (self = [super init]) {
        _currentPage = 1;
        _totalPage   = 0;
    }
    return self;
}

- (void)requestHomeChannelWithParam:(id)paramaters completeHandler:(void (^)(NSString *message, BOOL isSuccess))completeHandler {
    
    NSString *changeId = [paramaters ds_stringForKey:@"channel_id"];
    NSString *pageNO   = [paramaters ds_stringForKey:@"page"];
    ZFHomeChannelApi *channelApi = [[ZFHomeChannelApi alloc] initWithChannelId:changeId pageNO:pageNO pageSize:@"10"];
    [channelApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON                 = request.responseJSONObject;
        NSInteger statusCode           = [requestJSON ds_integerForKey:@"statusCode"];
        NSDictionary *resultDictionary = [requestJSON ds_dictionaryForKey:@"result"];
        // 成功
        if (statusCode == 200) {
            
            NSArray *bannerDictArray      = [resultDictionary ds_arrayForKey:@"banner_list"];
            NSDictionary *goodsDict       = [resultDictionary ds_dictionaryForKey:@"goods_list"];
            NSArray *nGoodsDictArray      = [goodsDict ds_arrayForKey:@"goods_list"];
            _currentPage = [goodsDict ds_integerForKey:@"cur_page"];
            _totalPage   = [goodsDict ds_integerForKey:@"total_page"];
            
            NSMutableArray *bannerMArray   = [[NSMutableArray alloc] initWithCapacity:bannerDictArray.count];
            NSMutableArray *nGoodsMArray   = [[NSMutableArray alloc] initWithCapacity:nGoodsDictArray.count];
            if ([pageNO integerValue] > 1) {
                [nGoodsMArray addObjectsFromArray:self.goodsArray];
            } else {
                self.goodsArray  = nil;
                self.bannerArray = nil;
            }
            
            for (NSDictionary *bannerDict in bannerDictArray) {
                ZFChannelBannerModel *channelBannerModel = [ZFChannelBannerModel yy_modelWithJSON:bannerDict];
                BannerModel *model = [self adapterWithChannelBanner:channelBannerModel];
                [bannerMArray addObject:model];
            }
            self.bannerArray = bannerMArray;
            
            for (NSDictionary *goodsDict in nGoodsDictArray) {
                ZFChannelGoodsModel *channelGoodsModel = [ZFChannelGoodsModel yy_modelWithJSON:goodsDict];
                GoodsModel *model = [self adapterWithChannelGoods:channelGoodsModel];
                [nGoodsMArray addObject:model];
            }
            self.goodsArray = nGoodsMArray;
            
            [self googleAnalytic];
            completeHandler(nil, YES);
        } else { // 失败
            
            NSString *message = [resultDictionary ds_stringForKey:@"msg"];
            completeHandler(message, NO);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        completeHandler(error.localizedDescription, NO);
    }];
}

- (NSInteger)currentPage {
    return _currentPage;
}

- (NSInteger)totalPages {
    return _totalPage;
}

#pragma mark - private method
- (BannerModel *)adapterWithChannelBanner:(ZFChannelBannerModel *)channerBanner {
    
    BannerModel *bannerModel  = [[BannerModel alloc] init];
    
    bannerModel.banner_height = channerBanner.bannerImgHeight;
    bannerModel.deeplink_uri  = channerBanner.deepLinkURL;
    bannerModel.image         = channerBanner.bannerImgURL;
    bannerModel.title         = channerBanner.bannerName;
    
    return bannerModel;
}

- (GoodsModel *)adapterWithChannelGoods:(ZFChannelGoodsModel *)channelGoodsModel {
    
    GoodsModel *goodsModel = [[GoodsModel alloc] init];
    
    goodsModel.wp_image    = channelGoodsModel.wpImage;
    goodsModel.goods_thumb = channelGoodsModel.goodsThumb;
    goodsModel.goods_img   = channelGoodsModel.goodsImgURL;
    goodsModel.goods_grid  = channelGoodsModel.goodsGrid;
//    goodsModel.original_img = channelGoodsModel.orig
    goodsModel.goods_brief = channelGoodsModel.goodsBrief;
    
//    goodsModel.goods_desc = channelGoodsModel.goodsd
//    @property (nonatomic, copy) NSString * attr_color;
//    @property (nonatomic, copy) NSString * attr_size;
    goodsModel.goods_weight = channelGoodsModel.goodsWeight;
    goodsModel.goods_title = channelGoodsModel.goodsTitle;
    goodsModel.goods_sn = channelGoodsModel.goodsSN;
    
    goodsModel.goods_id        = [channelGoodsModel.goodsId integerValue];
    goodsModel.cat_id          = [channelGoodsModel.cateId integerValue];
    goodsModel.is_promote      = [channelGoodsModel.isPromote boolValue];
    goodsModel.is_mobile_price = [channelGoodsModel.isMobilePrice boolValue];
    goodsModel.goods_number    = [channelGoodsModel.goodsNumber integerValue];
//    goodsModel.isonsale = [channelGoodsModel.iso];
    
//    @property (nonatomic, assign) NSInteger add_time;
    goodsModel.promote_zhekou = [channelGoodsModel.promoteZheKou integerValue];
//    @property (nonatomic, assign) NSInteger more_color;
    goodsModel.activityType   = [channelGoodsModel.activityType integerValue];

    goodsModel.market_price   = [channelGoodsModel.marketPrice doubleValue];
    goodsModel.shop_price     = [channelGoodsModel.shopPrice doubleValue];
    goodsModel.is_cod         = [channelGoodsModel.isCod boolValue];
    
    return goodsModel;
}

#pragma mark - 谷歌统计
- (void)googleAnalytic {
    // 谷歌统计
    if (self.bannerArray.count > 0) {
        [self analyticsHomeBannerWithBannerArray:self.bannerArray name:@"ChannelBannerSession"];
    }
    
    if (self.goodsArray.count > 0) {
        // 谷歌统计
        [ZFAnalytics showProductsWithProducts:self.goodsArray position:1 impressionList:@"Channel - List" screenName:@"Channel" event:nil];
    }
}

- (void)analyticsHomeBannerWithBannerArray:(NSArray<BannerModel *> *)banners name:(NSString *)name{
    NSMutableArray *screenNames = [NSMutableArray array];
    for (int i = 0; i < banners.count; i++) {
        BannerModel * banner = banners[i];
        NSString *screenName = [NSString stringWithFormat:@"%@ - %@",name,banner.title];
        NSString *position = [NSString stringWithFormat:@"%@ - P%d",name, i+1];
        [screenNames addObject:@{@"name":screenName,@"position":position}];
    }
    [ZFAnalytics showAdvertisementWithBanners:screenNames position:nil screenName:@"Home"];
}

@end
