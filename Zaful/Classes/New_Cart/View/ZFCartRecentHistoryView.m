
//
//  ZFCartRecentHistoryTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartRecentHistoryView.h"
#import "ZFInitViewProtocol.h"
#import "CartOperationManager.h"
#import "CommendModel.h"
#import "ZFCartRecentHistoryCollectionViewCell.h"


static NSString *kZFCartRecentHistoryCollectionViewCellIdentifier = @"kZFCartRecentHistoryCollectionViewCellIdentifier";

@interface ZFCartRecentHistoryView () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel                       *historyLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout    *flowLayout;
@property (nonatomic, strong) UICollectionView              *collectionView;

@end

@implementation ZFCartRecentHistoryView
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - interface methods
- (void)changeCommendGoodsListInfo {
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[CartOperationManager sharedManager] recentList].count;
}

// 内容边框
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

// cell 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150 * SCREEN_WIDTH_SCALE, 200 * SCREEN_WIDTH_SCALE + 58);
}

// cell 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

// cell 列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCartRecentHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCartRecentHistoryCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.itemModel = [[CartOperationManager sharedManager] recentList][indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CommendModel *model = [[CartOperationManager sharedManager] recentList][indexPath.row];
    if (self.cartRecentHistoryGoodsDetailCompletionHandler) {
        self.cartRecentHistoryGoodsDetailCompletionHandler(model.goodsId);
        
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Bag_History_Goods_%@", model.goodsId] itemName:model.goodsName ContentType:@"Goods" itemCategory:@"Bag_History"];
    }
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Cart" actionName:@"Cart - Your Recent History" label:@"Cart - Your Recent History Tab"];
    [ZFAnalytics clickHistoryProductWithProduct:model position:0 actionList:@"Cart Recommend"];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.historyLabel];
    [self addSubview:self.collectionView];
}

- (void)zfAutoLayoutView {
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(12);
        make.top.mas_equalTo(self);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        make.height.mas_equalTo(40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.historyLabel.mas_bottom);
    }];
}

#pragma mark - getter
- (UILabel *)historyLabel {
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _historyLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _historyLabel.font = [UIFont systemFontOfSize:18];
        _historyLabel.text = ZFLocalizedString(@"Bag_RecentHistory",nil);
    }
    return _historyLabel;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = ZFCOLOR_WHITE;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZFCartRecentHistoryCollectionViewCell class] forCellWithReuseIdentifier:kZFCartRecentHistoryCollectionViewCellIdentifier];
        
    }
    return _collectionView;
}

@end
