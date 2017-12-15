
//
//  ZFCommunityExploreBannersCell.m
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityExploreBannersCell.h"
#import "ZFInitViewProtocol.h"
#import "SDCycleScrollView.h"
#import "ZFBannerScrollView.h"
#import "ZFCommunityExploreModel.h"
#import "BannerModel.h"

@interface ZFCommunityExploreBannersCell () <ZFInitViewProtocol, SDCycleScrollViewDelegate,ZFBannerScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView     *bannerScrollView;
//@property (nonatomic, strong) ZFBannerScrollView     *bannerScrollView;
@end

@implementation ZFCommunityExploreBannersCell

#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <SDCycleScrollViewDelegate>
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *bannerModel = self.model.bannerlist[index];
    if (self.jumpToBannerCompletionHandler) {
        self.jumpToBannerCompletionHandler(bannerModel);
    }
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Community" actionName:@"Community - Banner" label:@"Community - Banner Tab"];
    NSString *GABannerId = bannerModel.key;
    NSString *GABannerName = [NSString stringWithFormat:@"CommunityBanner - %@",bannerModel.title];
    NSString *position = [NSString stringWithFormat:@"CommunityBanner - P%ld", (long)(index +1)];
    [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
    
}

-(void)ZFBannerScrollView:(ZFBannerScrollView *)view didSelectItemAtIndex:(NSInteger)index {
    BannerModel *bannerModel = self.model.bannerlist[index];
    if (self.jumpToBannerCompletionHandler) {
        self.jumpToBannerCompletionHandler(bannerModel);
    }
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Community" actionName:@"Community - Banner" label:@"Community - Banner Tab"];
    NSString *GABannerId = bannerModel.key;
    NSString *GABannerName = [NSString stringWithFormat:@"CommunityBanner - %@",bannerModel.title];
    NSString *position = [NSString stringWithFormat:@"CommunityBanner - P%ld", (long)(index +1)];
    [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
}




#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self.contentView addSubview:self.bannerScrollView];
}

- (void)zfAutoLayoutView {
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunityExploreModel *)model {
    _model = model;
    if (![NSArrayUtils isEmptyArray:model.bannerlist]) {
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:model.bannerlist.count];
        
        [model.bannerlist enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArray addObject:obj.image];
        }];
        
        self.bannerScrollView.imageURLStringsGroup = imageArray;
        self.bannerScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
        if (imageArray.count == 1) {
            self.bannerScrollView.autoScroll = NO;
        }
    }
}

#pragma mark - getter
- (SDCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"community_index_banner_loading"]];
        _bannerScrollView.autoScrollTimeInterval = 3.0; // 间隔时间
        _bannerScrollView.currentPageDotColor = ZFCOLOR(51, 51, 51, 1.0);
        _bannerScrollView.pageDotColor = ZFCOLOR(241, 241, 241, 1.0);

    }
    return _bannerScrollView;
}

//- (ZFBannerScrollView *)bannerScrollView {
//    if (!_bannerScrollView) {
//        _bannerScrollView = [[ZFBannerScrollView alloc] init];
//        _bannerScrollView.bannerType = ZFBannerTypeParallax;
//        _bannerScrollView.delegate = self;
//    }
//    return _bannerScrollView;
//}

@end

