

//
//  ZFCommunityHotMoreVideoBannerCell.m
//  Zaful
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityHotMoreVideoBannerCell.h"
#import "ZFInitViewProtocol.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"

@interface ZFCommunityHotMoreVideoBannerCell () <ZFInitViewProtocol, SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView         *bannerView;
@end


@implementation ZFCommunityHotMoreVideoBannerCell
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
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *bannerModel = self.bannerArray[index];
    if (self.moreHotVideoBannerJumpCompletionHandler) {
        self.moreHotVideoBannerJumpCompletionHandler(bannerModel);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.bannerView];
}

- (void)zfAutoLayoutView {
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setBannerArray:(NSMutableArray<BannerModel *> *)bannerArray {
    _bannerArray = bannerArray;
    if (_bannerArray.count <= 0) {
        return ;
    }
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:_bannerArray.count];
    [_bannerArray enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:obj.image];
    }];
    _bannerView.imageURLStringsGroup = imageArray;
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    if (imageArray.count == 1) {
        _bannerView.autoScroll = NO;
    }
}

#pragma mark - getter
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                         delegate:self
                                                 placeholderImage:[UIImage imageNamed:@"community_index_banner_loading"]];
        _bannerView.autoScrollTimeInterval = 3.0; // 间隔时间
        _bannerView.currentPageDotColor = ZFCOLOR(51, 51, 51, 1.0);
        _bannerView.pageDotColor = ZFCOLOR(241, 241, 241, 1.0);
    }
    return _bannerView;
}

@end
