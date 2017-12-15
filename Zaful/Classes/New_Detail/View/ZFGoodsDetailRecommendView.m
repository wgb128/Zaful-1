
//
//  ZFGoodsDetailRecommendView.m
//  Zaful
//
//  Created by liuxi on 2017/11/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailRecommendView.h"
#import "ZFInitViewProtocol.h"
#import "GoodsDetailSameModel.h"
#import "ZFRecommendInfoCollectionViewCell.h"

static NSString *const kZFRecommendInfoCollectionViewCellIdentifier = @"kZFRecommendInfoCollectionViewCellIdentifier";

@interface ZFGoodsDetailRecommendView() <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel                           *titleLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout        *flowLayout;
@property (nonatomic, strong) UICollectionView                  *collectionView;
@end

@implementation ZFGoodsDetailRecommendView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count > 6 ? 6 : self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFRecommendInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFRecommendInfoCollectionViewCellIdentifier forIndexPath:indexPath];
    if ([SystemConfigUtils isRightToLeftShow]) {
        cell.transform = CGAffineTransformMakeRotation(M_PI);
    }
    GoodsDetailSameModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150 * SCREEN_WIDTH_SCALE, 200 * SCREEN_WIDTH_SCALE + 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailSameModel *model = self.dataArray[indexPath.row];
    if (self.goodsDetailRecommendSelectCompletionHandler) {
        self.goodsDetailRecommendSelectCompletionHandler(model.goods_id);
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Detail" actionName:@"Product Detail - Recommand" label:@"Product Detail - Recommand"];
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_top).offset(24);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.bottom.leading.trailing.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
- (void)setDataArray:(NSArray<GoodsDetailSameModel *> *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = ZFLocalizedString(@"Detail_Product_Recommend",nil);
    }
    return _titleLabel;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 12;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.alwaysBounceHorizontal = NO;
        [_collectionView registerClass:[ZFRecommendInfoCollectionViewCell class] forCellWithReuseIdentifier:kZFRecommendInfoCollectionViewCellIdentifier];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _collectionView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
    }
    return _collectionView;
}

@end
