//
//  HomeBannerCell.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeBannerCell.h"
#import "ZFBannerScrollView.h"

@interface HomeBannerCell()<ZFBannerScrollViewDelegate>
@property (nonatomic, strong) ZFBannerScrollView   *bannerScrollView;
@end

@implementation HomeBannerCell
+ (HomeBannerCell *)homeBannerCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[HomeBannerCell class]  forCellWithReuseIdentifier:NSStringFromClass([self class])];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZFCOLOR_WHITE;
        [self addSubview:self.bannerScrollView];
        [self.bannerScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(@0);
            make.height.mas_equalTo(@(300 * DSCREEN_WIDTH_SCALE));
        }];
        
    }
    return self;
}

- (ZFBannerScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[ZFBannerScrollView alloc] init];
        _bannerScrollView.bannerType = ZFBannerTypeParallax;
        _bannerScrollView.delegate = self;
    }
    return _bannerScrollView;
}

- (void)setBannerModelArray:(NSArray *)bannerModelArray {

    _bannerModelArray = bannerModelArray;
    
    if (_bannerModelArray == nil || _bannerModelArray.count == 0){
        [self.bannerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
        return;
    } else {
        [self.bannerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(300 * DSCREEN_WIDTH_SCALE));
        }];
    }

    NSMutableArray *imageArray = [NSMutableArray array];
    for (BannerModel *model in _bannerModelArray) {
        [imageArray addObject:model.image];
    }
    
    self.bannerScrollView.imageURLStringsGroup = imageArray;
}

#pragma mark - 点击事件
/** 点击 Banner 图片回调 */
- (void)ZFBannerScrollView:(ZFBannerScrollView *)view didSelectItemAtIndex:(NSInteger)index {
    BannerModel * bannerModel  = _bannerModelArray[index];
    if (self.homeBannerClick) {
        _homeBannerClick(bannerModel);
    }
}



@end

